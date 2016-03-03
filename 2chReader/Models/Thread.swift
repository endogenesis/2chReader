//
//  Thread.swift
//  2chReader
//
//  Created by NIkolay Tsygankov on 2/3/16.
//  Copyright © 2016 Endogenesis. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class Thread: Object, Mappable {
    
    dynamic var threadNum: String?
    var subject: String? {
        let firstPostInThread = posts.first
        if (firstPostInThread?.subject == "") {
            return threadNum
        }
        return firstPostInThread?.subject
    }
    var posts = List<Post>()
    
    
    dynamic var postCount = 0
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        threadNum <- map["thread_num"]
        posts <- (map["posts"], ArrayTransform<Post>())
        postCount <- map["posts_count"]
    }
    
    override class func primaryKey() -> String {
        return "threadNum"
    }

}
