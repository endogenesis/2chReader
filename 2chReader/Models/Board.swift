//
//  Board.swift
//  2chReader
//
//  Created by NIkolay Tsygankov on 3/10/16.
//  Copyright © 2016 Endogenesis. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class BoardRealm: Object, Mappable {
    
    dynamic var id: String = "no id"
    var threads = List<Thread>()
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["Board"]
        threads <- (map["threads"], ArrayTransform<Thread>())
    }
    
    override class func primaryKey() -> String {
        return "id"
    }
}
