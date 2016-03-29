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
    
    func loadPosts(boardID: String, threadNum: String, fromPost: Int, callback:([Post]? -> Void)) {
        
        let urlString = self.urlGetPosts(boardID, thread: threadNum, postThreadNumber: fromPost + 1)
        
        Alamofire.request(.GET, urlString).validate().responseArray { (response: Response<[Post], NSError>) -> Void in
            switch response.result {
            case .Success:
                let posts = response.result.value
                if let posts = posts {
                    callback(posts)
                } else {
                    callback(nil)
                }
            case .Failure(let error):
                print(error)
                callback(nil)
            }
        }
    }
    
    //MARK: Utils
    
    func urlGetThreads(board: String, page: Int) -> String {
        // example: "https://2ch.hk/bi/index.json"
        
        let pageString:String
        if page == 0 {
            pageString = "index"
        } else {
            pageString = String(page)
        }
        
        let urlString = self.dvachURL + board + "/" + pageString + ".json"
        return urlString
    }
    
    func urlGetPosts(board: String, thread :String, postThreadNumber: Int) -> String {
        // example: https://2ch.hk/makaba/mobile.fcgi?task=get_thread&board=abu&thread=42375&post=0
        
        let urlString = String(format: "https://2ch.hk/makaba/mobile.fcgi?task=get_thread&board=%@&thread=%@&post=%@", arguments: [board, thread, String(postThreadNumber)])
        return urlString
    }
    
    func urlForImage(board:String, path:String) -> String {
        let urlString = self.dvachURL + board + "/" + path
        return urlString
    }
}
