//
//  Post.swift
//  2chReader
//
//  Created by NIkolay Tsygankov on 2/5/16.
//  Copyright © 2016 Endogenesis. All rights reserved.
//

import UIKit
import ObjectMapper

class Post: Mappable {
    
    var comment: String?
    var num: String?
    var subject: String?
    var date :String?
    
    var postDate: NSDate? {
            if let time = self.timestamp {
                let postDate = NSDate(timeIntervalSince1970: NSTimeInterval(Double(time)))
                return postDate
            } else {
                return nil
            }
        }
    var timestamp: Int?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        comment <- map["comment"]
        num <- map["num"]
        subject <- map["subject"]
        date <- map["date"]
        timestamp <- map["timestamp"]
    }
}
