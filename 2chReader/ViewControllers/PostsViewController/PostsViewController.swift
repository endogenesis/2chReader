//
//  PostsViewController.swift
//  2chReader
//
//  Created by NIkolay Tsygankov on 3/14/16.
//  Copyright © 2016 Endogenesis. All rights reserved.
//

import UIKit
import RealmSwift
import AlamofireImage

class PostsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var thread: Thread = Thread()
    var board: BoardRealm = BoardRealm()
    
    let attrStrBuilder = AttributedStringBuilder()
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(PostTableViewCell.nibPostTableViewCell(), forCellReuseIdentifier: PostTableViewCell.identifier())
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.navigationItem.title = self.thread.subject
    }
    
    override func viewWillAppear(animated: Bool) {
        ServerManager.sharedInstance.loadPosts(self.board.id, threadNum: self.thread.threadNum, fromPost: self.thread.posts.count ) { (posts) -> Void in
            if let posts = posts {
                self.savePostsToRealm(posts)
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
    }
    
    // MARK: - Realm
    func savePostsToRealm(posts: [Post]) {
        try! self.realm.write {
            //TODO need check posts on uniq num
            self.thread.posts.appendContentsOf(posts)
            self.realm.add(posts, update: true)
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.thread.posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(PostTableViewCell.identifier(), forIndexPath: indexPath) as! PostTableViewCell
        
        let post = self.thread.posts[indexPath.row]
        if let comment = post.comment {
            cell.postTextView.attributedText = self.attrStrBuilder.attributedString(comment)
            cell.postTextView.delegate = self
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
//                let attrStr = self.attrStrBuilder.attributedString(comment)
//                
//                dispatch_async(dispatch_get_main_queue(), { 
//                    cell.postTextView.attributedText = attrStr
//                })
//            })
        }
        
        let fileModel = post.files.first
        if let fileModel = fileModel {
            let imageUrl = NSURL(string: ServerManager.sharedInstance.urlForImage(self.board.id, path: fileModel.thumbPath!))
            cell.postImage?.af_setImageWithURL(imageUrl!)
        }
        
        return cell
    }
    
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100;
    }
    
    // MARK: - UITextViewDelegate
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        return false
    }
}
