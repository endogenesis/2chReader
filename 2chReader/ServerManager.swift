//
//  ServerManager.swift
//  2chReader
//
//  Created by NIkolay Tsygankov on 2/3/16.
//  Copyright © 2016 Endogenesis. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper


class ServerManager: NSObject {
    
    static let sharedInstance = ServerManager()
    
    let dvachURL = "https://2ch.hk/"
    
    func threadsFromBoard(board:String, page:Int, callback:([Thread]? -> Void)) {
        
        let pageString:String
        
        if page == 0 {
            pageString = "index"
        } else {
            pageString = String(page)
        }
        
        let urlString = dvachURL + board + "/" + pageString + ".json"
        
        Alamofire.request(.GET, urlString).responseArray("threads") { (response: Response<[Thread], NSError>) -> Void in
            let threads = response.result.value
            if let threads = threads {
                for thread in threads {
                    print(thread.threadNum)
                    callback(threads)
                }
            }
        }
        
    }

}
