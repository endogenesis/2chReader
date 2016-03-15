//
//  File.swift
//  2chReader
//
//  Created by NIkolay Tsygankov on 3/15/16.
//  Copyright © 2016 Endogenesis. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class File: Object, Mappable {
    
    dynamic var path: String?
    
    func mapping(map: Map) {
        path <- map["path"]
    }
}
