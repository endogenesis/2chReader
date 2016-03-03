//
//  Post.swift
//  2chReader
//
//  Created by NIkolay Tsygankov on 2/5/16.
//  Copyright © 2016 Endogenesis. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class Post: Object, Mappable {
    
    dynamic var comment: String?
    dynamic var num: String?
    dynamic var subject: String?
    dynamic var date :String?
    
//    var postDate: NSDate? {
//            if let time = self.timestamp {
//                let postDate = NSDate(timeIntervalSince1970: NSTimeInterval(Double(time)))
//                return postDate
//            } else {
//                return nil
//            }
//        }
    var timestamp: Int?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        comment <- map["comment"]
        num <- map["num"]
        subject <- map["subject"]
        date <- map["date"]
        timestamp <- map["timestamp"]
    }
}
