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

class ArrayTransform<T:RealmSwift.Object where T:Mappable> : TransformType {
    typealias Object = List<T>
    typealias JSON = Array<AnyObject>
    
    func transformFromJSON(value: AnyObject?) -> List<T>? {
        var result = List<T>()
        if let tempArr = value as! Array<AnyObject>? {
            for entry in tempArr {
                let mapper = Mapper<T>()
                let model : T = mapper.map(entry)!
                result.append(model)
            }
        }
        return result
    }
    
    // transformToJson was replaced with a solution by @zendobk from https://gist.github.com/zendobk/80b16eb74524a1674871
    // to avoid confusing future visitors of this gist. Thanks to @marksbren for pointing this out (see comments of this gist)
    func transformToJSON(value: Object?) -> JSON? {
        var results = [AnyObject]()
        if let value = value {
            for obj in value {
                let mapper = Mapper<T>()
                let json = mapper.toJSON(obj)
                results.append(json)
            }
        }
        return results
    }
}

class Thread: Object, Mappable {
    
    dynamic var threadNum: String?
    //dynamic var posts: [Post]?
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

}
