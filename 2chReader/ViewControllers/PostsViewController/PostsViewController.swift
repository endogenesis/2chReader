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

class PostsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var thread: Thread = Thread()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(PostTableViewCell.nibPostTableViewCell(), forCellReuseIdentifier: PostTableViewCell.identifier())
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.navigationItem.title = self.thread.subject
    }
    
    override func viewWillAppear(animated: Bool) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(self.thread.posts)
        }
        
        ServerManager.sharedInstance.loadThreadWithPosts((self.thread.owner?.id)!, threadNum: self.thread.threadNum!) { (posts) -> Void in
            if let posts = posts {
                try! realm.write {
                    self.thread.posts.appendContentsOf(posts)
                    realm.add(self.thread, update: true)
                }
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
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
        
        cell.labelComment.text = post.comment
        
        let fileModel = post.files.first
        if let fileModel = fileModel {
            let imageUrl = NSURL(string: ServerManager.sharedInstance.urlForImage(self.thread.owner!.id!, path: fileModel.thumbPath!))
            cell.postImage?.af_setImageWithURL(imageUrl!)
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100;
    }
    
    
}
