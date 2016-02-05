//
//  Thread.swift
//  2chReader
//
//  Created by NIkolay Tsygankov on 2/3/16.
//  Copyright © 2016 Endogenesis. All rights reserved.
//

import UIKit
import ObjectMapper

class Thread: Mappable {
    
    var threadNum: String?
    var posts: [Post]?
    var postCount: String?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        threadNum <- map["thread_num"]
        posts <- map["posts"]
        postCount <- map["postCount"]
    }

}
