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
    
    var name: String?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
    }

}
