//
//  RealmListTransform.swift
//  2chReader
//
//  Created by NIkolay Tsygankov on 3/3/16.
//  Copyright © 2016 Endogenesis. All rights reserved.
//

import ObjectMapper
import RealmSwift

class ArrayTransform<T:RealmSwift.Object where T:Mappable> : TransformType {
    typealias Object = List<T>
    typealias JSON = Array<AnyObject>
    
    func transformFromJSON(value: AnyObject?) -> List<T>? {
        let result = List<T>()
        if let tempArr = value as! Array<AnyObject>? {
            for entry in tempArr {
                let mapper = Mapper<T>()
                let model : T = mapper.map(entry)!
                result.append(model)
            }
        }
        return result
    }
    
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