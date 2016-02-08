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
    let id: String
    let name: String
    var category: BoardCategory?
    
    init(id: String, name: String, category: BoardCategory) {
        self.id = id
        self.name = name
        self.category = category
    }
    
    init(dict: NSDictionary) {
        self.id = dict["boardId"] as! String
        self.name = dict["name"] as! String
        self.category = BoardCategory(rawValue: Int(dict["categoryId"] as! NSNumber))
        guard self.category != nil else {
            self.category = .None
            return
        }
    }
}

class ResourceManager: NSObject {
    
    func boards() -> [[Board]] {
        
        let path = NSBundle.mainBundle().pathForResource("Boards", ofType: "plist")
        let boardsJSONArray = NSArray(contentsOfFile: path!)!
        
        var boards:[Board] = []
        
        for item in boardsJSONArray {
            let boardDict = item as! NSDictionary
            let board = Board(dict: boardDict)
            boards.append(board)
        }
        
        var arrayThemeCentered :[Board] = []
        var arrayCreation :[Board] = []
        var arrayHardwareSoft :[Board] = []
        var arrayGames :[Board] = []
        var arrayNone :[Board] = []
        
        
        for board:Board in boards {
            switch board.category! {
            case .Creation: arrayCreation.append(board)
            case .Games: arrayGames.append(board)
            case .HardwareSoft: arrayHardwareSoft.append(board)
            case .ThemeCentered: arrayThemeCentered.append(board)
            case .None: arrayNone.append(board)
            }
            
        }
        
        let arrayOfBoardsArray: [[Board]] = [arrayThemeCentered, arrayCreation, arrayHardwareSoft, arrayGames, arrayNone]
        
        return arrayOfBoardsArray
    }

}
