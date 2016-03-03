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
        
        let urlString = dvachURL + board + "/" + pageString + ".json" //"https://2ch.hk/bi/index.json"
        
        Alamofire.request(.GET, urlString).validate().responseArray("threads") { (response: Response<[Thread], NSError>) -> Void in
            switch response.result {
            case .Success:
                let threads = response.result.value
                if let threads = threads {
                    callback(threads)
                } else {
                    callback(nil)
                }
            case .Failure(let error):
                print(error)
                callback(nil)
            }
        }
    }
}
