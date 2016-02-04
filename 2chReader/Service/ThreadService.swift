//
//  ThreadService.swift
//  2chReader
//
//  Created by NIkolay Tsygankov on 2/4/16.
//  Copyright © 2016 Endogenesis. All rights reserved.
//

import UIKit
import AlamofireObjectMapper
import Mapper

class ThreadService: NSObject {
    
    let serverManager = ServerManager.sharedInstance
    
    func getThreads(board:String, page:Int, callback: ([Thread?]) -> Void ) {
        serverManager.threadsFromBoard(board, page: page) { (response) -> Void in
            print(response)
            let testThread = Mapper<Thread>().map(response)
            callback([testThread])
        }
    }

}
