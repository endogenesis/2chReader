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
let boldTag = (regExp:"<strong>.*?</strong>", attributes: boldAttributes)

let italicFont = UIFont.italicSystemFontOfSize(defaultFontSize)
let italicAttributes = [NSFontAttributeName : italicFont]
let italicTag = (regExp:"<em>.*?</em>", attributes: italicAttributes)

struct TagToProcess {
    let regExp: String
    let attributes: [String : UIFont]
    let openLength: Int
    let closedLength: Int
}

let boldTag1 = TagToProcess(regExp: "<strong>.*?</strong>", attributes: boldAttributes, openLength: 8, closedLength: 9)
let italicTag1 = TagToProcess(regExp: "<em>.*?</em>", attributes: italicAttributes, openLength: 4, closedLength: 5)


class AttibutedStringBuilder {
    
    let tagsToProcess = [boldTag1, italicTag1]
    
    func attributedString(stringWithTags: String) -> NSAttributedString? {
        
        let attrStr = NSMutableAttributedString(string: stringWithTags)
        
        for tag in self.tagsToProcess {
            var rangeOfSearchText = self.findTextWithTag(tag.regExp, str: attrStr.mutableString as String)
            while rangeOfSearchText.length != 0 {
                let rangeWithoutTags = self.removeTagsFromString(attrStr.mutableString, range: &rangeOfSearchText, open: tag.openLength, closed: tag.closedLength)
                attrStr.addAttributes(tag.attributes, range: rangeWithoutTags)
                rangeOfSearchText = self.findTextWithTag(tag.regExp, str: attrStr.mutableString as String)
            }
        }
        return attrStr
    }
    
    func findTextWithTag(regExp: String, str: String) -> NSRange {
        
        let regex = try! NSRegularExpression(pattern: regExp, options: .CaseInsensitive)
        
        let result =  regex.firstMatchInString(str, options: .ReportProgress, range: NSRange(location: 0, length: str.characters.count))
        
        if let result = result {
            return result.range
        } else {
            return NSRange(location: 0, length: 0)
        }
    }
    
    func removeTagsFromString(str: NSMutableString, inout range: NSRange, open: Int, closed: Int) -> NSRange {
        
        let openTagRange = NSRange(location: range.location, length: open)
        str.deleteCharactersInRange(openTagRange)
        range.length -= open
        
        let closedTagRange = NSRange(location: range.location + range.length - closed, length: closed)
        str.deleteCharactersInRange(closedTagRange)
        range.length -= closed
        return range
    }
}
