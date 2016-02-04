//
//  ServerManager.swift
//  2chReader
//
//  Created by NIkolay Tsygankov on 2/3/16.
//  Copyright © 2016 Endogenesis. All rights reserved.
//

import UIKit
import Alamofire


class ServerManager: NSObject {
    
    static let sharedInstance = ServerManager()
    
    let dvachURL = "https://2ch.hk/"
    
    func threadsFromBoard(board:String, page:Int, callback:(AnyObject? -> Void)) {
        
        let pageString:String
        
        if page == 0 {
            pageString = "index"
        } else {
            pageString = String(page)
        }
        
        let urlString = dvachURL + board + "/" + pageString + ".json"
        
        Alamofire.request(.GET, urlString).validate().responseJSON { response in
            switch response.result {
            case .Success:
                print(response.result.value)
                callback(response.result.value)
            case.Failure(let error):
                print(error)
                callback(nil)
            }
        }
    }

}
