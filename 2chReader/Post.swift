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
    var subject :String?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        comment <- map["comment"]
        num <- map["num"]
        subject <- map["subject"]
    }

}
