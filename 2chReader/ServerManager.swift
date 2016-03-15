//
//  ServerManager.swift
//  2chReader
//
//  Created by NIkolay Tsygankov on 2/3/16.
//  Copyright © 2016 Endogenesis. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import AlamofireObjectMapper


class ServerManager: NSObject {
    
    static let sharedInstance = ServerManager()
    
    let dvachURL = "https://2ch.hk/"
    
    
    //MARK: Server Methods
    
    func threadsFromBoard(board:String, page:Int, callback:([Thread]? -> Void)) {
        
        let urlString = self.urlGetThreads(board, page: page)
        
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

    func boardWithThreads(board:String, page:Int, callback:(BoardRealm? -> Void)) {
        
        let urlString = self.urlGetThreads(board, page: page)
        
        Alamofire.request(.GET, urlString).validate().responseObject { (response: Response<BoardRealm, NSError>) -> Void in
            switch response.result {
            case .Success:
                let boardWithThreads = response.result.value
                if let boardWithThreads = boardWithThreads {
                    callback(boardWithThreads)
                } else {
                    callback(nil)
                }
            case .Failure(let error):
                print(error)
                callback(nil)
            }
        }
    }
    
    func loadImage(board:String, path:String, callback:(UIImage? -> Void)) {
        
        Alamofire.request(.GET, self.urlForImage(board, path: path)).responseImage { response in
                debugPrint(response)
                
                print(response.request)
                print(response.response)
                debugPrint(response.result)
                
                if let image = response.result.value {
                    print("image downloaded: \(image)")
                }
        }
        
    }
    
    //MARK: Utils
    
    func urlGetThreads(board:String, page:Int) -> String {
        let pageString:String
        
        if page == 0 {
            pageString = "index"
        } else {
            pageString = String(page)
        }
        
        let urlString = self.dvachURL + board + "/" + pageString + ".json"
        // example: "https://2ch.hk/bi/index.json"
        return urlString
    }
    
    func urlForImage(board:String, path:String) -> String {
        let urlString = self.dvachURL + board + "/" + path
        return urlString
    }
}
