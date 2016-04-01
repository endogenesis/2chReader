//
//  AttributedStringBuilder.swift
//  2chReader
//
//  Created by NIkolay Tsygankov on 3/24/16.
//  Copyright © 2016 Endogenesis. All rights reserved.
//

import Foundation
import UIKit

let defaultFontSize: CGFloat = 17

let boldFont = UIFont.boldSystemFontOfSize(defaultFontSize)
let boldAttributes = [NSFontAttributeName : boldFont]

let italicFont = UIFont.italicSystemFontOfSize(defaultFontSize)
let italicAttributes = [NSFontAttributeName : italicFont]

let linkAttributesURL  = [NSLinkAttributeName : "http://www.google.com" ]

let underlineAttributes = [NSUnderlineStyleAttributeName : NSUnderlineStyle.StyleSingle.rawValue]

let strikeAttribures = [NSStrikethroughStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]

struct TagToProcess {
    let regExp: String
    let attributes: [[String : AnyObject]]
    let openLength: Int
    let closedLength: Int
}

let boldTag = TagToProcess(regExp: "<strong>[\\s\\S]*?</strong>", attributes: [boldAttributes], openLength: 8, closedLength: 9)
let italicTag = TagToProcess(regExp: "<em>[\\s\\S]*?</em>", attributes: [italicAttributes], openLength: 4, closedLength: 5)
let linkTag = TagToProcess(regExp: "<a[^>]*>[\\s\\S]*?</a>", attributes: [linkAttributesURL], openLength: 3, closedLength: 4)
let underlineTag = TagToProcess(regExp: "<span class=\"u\">(.*?)</span>", attributes: [underlineAttributes], openLength: 5, closedLength: 7)
let strikeTag = TagToProcess(regExp: "<span class=\"s\">(.*?)</span>", attributes: [strikeAttribures], openLength: 7, closedLength: 5)

// spoiler and quote are coming


class AttributedStringBuilder {
    
    let tagsToProcess = [boldTag, italicTag, linkTag, underlineTag, strikeTag]
    
    func attributedString(stringWithTags: String) -> NSAttributedString? {
        
        let attrStr = NSMutableAttributedString(string: self.replaceSymbols(stringWithTags))
        
        for tag in self.tagsToProcess {
            var rangeOfSearchText = self.findTextWithTag(tag.regExp, str: attrStr.mutableString as String)
            while rangeOfSearchText.length != 0 {
                let rangeWithoutTags = self.removeTagsFromString(attrStr.mutableString, range: &rangeOfSearchText, open: tag.openLength, closed: tag.closedLength)
                for attributes in tag.attributes {
                    attrStr.addAttributes(attributes, range: rangeWithoutTags)
                }
                rangeOfSearchText = self.findTextWithTag(tag.regExp, str: attrStr.mutableString as String)
            }
        }
        return attrStr
    }
    
    // MARK: -
    
    private func replaceSymbols(string: String) -> String {
        var returnStr = string.stringByReplacingOccurrencesOfString("&#39;", withString: "'")
        returnStr = returnStr.stringByReplacingOccurrencesOfString("&#44;", withString: ",")
        returnStr = returnStr.stringByReplacingOccurrencesOfString("&#47;", withString: "/")
        returnStr = returnStr.stringByReplacingOccurrencesOfString("&#92;", withString: "\\")
        return returnStr.stringByReplacingOccurrencesOfString("<br>", withString: "\n")
    }
    
    // MARK: Utils
    
    private func findTextWithTag(regExp: String, str: String) -> NSRange {
        
        let regex = try! NSRegularExpression(pattern: regExp, options: .CaseInsensitive)
        
        let result =  regex.firstMatchInString(str, options: .ReportProgress, range: NSRange(location: 0, length: str.characters.count))
        
        if let result = result {
            return result.range
        } else {
            return NSRange(location: 0, length: 0)
        }
    }
    
    private func removeTagsFromString(str: NSMutableString, inout range: NSRange, open: Int, closed: Int) -> NSRange {
        
        let openTagRange = NSRange(location: range.location, length: open)
        str.deleteCharactersInRange(openTagRange)
        range.length -= open
        
        let closedTagRange = NSRange(location: range.location + range.length - closed, length: closed)
        str.deleteCharactersInRange(closedTagRange)
        range.length -= closed
        return range
    }
}
