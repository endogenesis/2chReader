//
//  AttributedStringBuilder.swift
//  2chReader
//
//  Created by NIkolay Tsygankov on 3/24/16.
//  Copyright © 2016 Endogenesis. All rights reserved.
//

import Foundation
import UIKit

let defaultFontSize: CGFloat = 20

let boldFont = UIFont.boldSystemFontOfSize(defaultFontSize)
let boldAttributes = [NSFontAttributeName : boldFont]
let boldTag = (regExp:"<strong>.*?</strong>", attributes: boldAttributes)

class AttibutedStringBuilder {
    
    let tagsToProcess = [boldTag]
    
    func attributedString(stringWithTags: String) -> NSAttributedString? {
        
        let attrStr = NSMutableAttributedString(string: stringWithTags)
        
        var strToProcess = stringWithTags
        for tag in self.tagsToProcess {
            var rangeOfSearchText = self.findTextWithTag(tag.regExp, str: strToProcess)
            while rangeOfSearchText.length != 0 {
                let rangeWithoutTags = self.removeTagsFromString(&strToProcess, range: &rangeOfSearchText)
                attrStr.addAttributes(tag.attributes, range: rangeWithoutTags)
                rangeOfSearchText = self.findTextWithTag(tag.regExp, str: strToProcess)
            }
        }
        return attrStr
    }
    
    func findTextWithTag(regExp: String, str: String) -> NSRange {
        
        let regex = try! NSRegularExpression(pattern: regExp, options: .CaseInsensitive)
        
        let result =  regex.firstMatchInString(str, options: .Anchored, range: NSRange(location: 0, length: str.characters.count))
        
        if let result = result {
            return result.range
        } else {
            return NSRange(location: 0, length: 0)
        }
    }
    
    func removeTagsFromString(inout str: String, inout range: NSRange) -> NSRange {
        let openTagRange = str.startIndex.advancedBy(range.location)...str.startIndex.advancedBy(range.location + 9)
        str.removeRange(openTagRange)
        range.length -= 9
        
        let closedTagRange = str.startIndex.advancedBy(range.location + range.length - 9)...str.startIndex.advancedBy(range.location + range.length)
        str.removeRange(closedTagRange)
        range.length -= 9
        return range
    }
}
