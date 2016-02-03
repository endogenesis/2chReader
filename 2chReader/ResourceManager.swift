//
//  ResourceManager.swift
//  2chReader
//
//  Created by NIkolay Tsygankov on 2/2/16.
//  Copyright © 2016 Endogenesis. All rights reserved.
//

import UIKit

enum BoardCategory: Int {
    case ThemeCentered = 1
    case Creation
    case HardwareSoft
    case Games
    case None
}

struct Board {
    var id: String
    var name: String
    var category: BoardCategory
    
    init(id: String, name: String, category: BoardCategory) {
        self.id = id
        self.name = name
        self.category = category
    }
    
    init(dict: NSDictionary) {
        self.id = dict["boardId"] as! String
        self.name = dict["name"] as! String
        self.category = BoardCategory(rawValue: Int(dict["categoryId"] as! NSNumber))!
    }
}

class ResourceManager: NSObject {
    
    func boards() -> [Board] {
        
        let path = NSBundle.mainBundle().pathForResource("Boards", ofType: "plist")
        let boardsArray = NSArray(contentsOfFile: path!)!
        
        var boards:[Board] = []
        
        for item in boardsArray {
            let boardDict = item as! NSDictionary
            let board = Board(dict: boardDict)
            boards.append(board)
        }
        return boards
    }

}
