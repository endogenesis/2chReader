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

enum PostType: Int {
    case NoImagePost = 1
    case OneImagePost
    case ManyImagePost
}

class Post: Object, Mappable {
    
    dynamic var num: String?
    dynamic var comment: String?
    dynamic var subject: String?
    dynamic var date :String?
    var timestamp: Int?
    var files = List<FileModel>()
    
    var type: PostType {
        switch files.count {
        case 0:
            return .NoImagePost
        case 1:
            return .OneImagePost
        default:
            return .ManyImagePost
        }
    }
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        comment <- map["comment"]
        num <- map["num"]
        subject <- map["subject"]
        date <- map["date"]
        timestamp <- map["timestamp"]
        files <- (map["files"], ArrayTransform<FileModel>())
    }
    
    override class func primaryKey() -> String {
        return "num"
    }
}

enum FileModelType: Int {
    case FileModelImage
    case FileModelWebm
    case FileModelUnknown
}

class FileModel: Object, Mappable {
    
    dynamic var thumbPath: String?
    dynamic var fullImagePath: String?
    
    dynamic var type: Int = 0
    var fileModelType :FileModelType {
            switch type {
            case 1:
                return .FileModelImage
            case 6:
                return .FileModelWebm
            default:
                return .FileModelUnknown
            }
    }
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        thumbPath <- map["thumbnail"]
        fullImagePath <- map["path"]
        type <- map["type"]
    }
}

