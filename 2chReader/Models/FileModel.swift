//
//  FileModel.swift
//  2chReader
//
//  Created by NIkolay Tsygankov on 3/17/16.
//  Copyright © 2016 Endogenesis. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class FileModel: Object, Mappable {
    
    dynamic var thumbPath: String?
    dynamic var imagePath: String?
    

    func mapping(map: Map) {
        thumbPath <- map["thumb"]
        imagePath <- map["path"]
    }
}
