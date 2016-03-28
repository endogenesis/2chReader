//
//  ThreadsViewController.swift
//  2chReader
//
//  Created by NIkolay Tsygankov on 2/5/16.
//  Copyright © 2016 Endogenesis. All rights reserved.
//

import UIKit
import RealmSwift
import AlamofireImage

class ThreadsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentBoardID: String = ""
    var board: BoardRealm = BoardRealm()
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(ThreadTableViewCell.nibThreadTableViewCell(), forCellReuseIdentifier: ThreadTableViewCell.identifier())
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.loadBoardFromRealm()
        
        ServerManager.sharedInstance.boardWithThreads(self.currentBoardID, page: 0) { (board) -> Void in
            if let board = board {
                self.board = board
                self.saveBoardToRealm(board)
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        let vc = segue.destinationViewController as! PostsViewController
        vc.thread =  self.board.threads[sender!.row]
        vc.board = self.board
    }
    
    // MARK: - Realm
    
    func loadBoardFromRealm() {
        let boardFromRealm = realm.objectForPrimaryKey(BoardRealm.self, key: self.currentBoardID)
        if let boardFromRealm = boardFromRealm {
            self.board = boardFromRealm
        }
    }
    
    func saveBoardToRealm(board: BoardRealm) {
        try! self.realm.write {
            self.realm.add(self.board, update:true)
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.board.threads.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(ThreadTableViewCell.identifier(), forIndexPath: indexPath) as! ThreadTableViewCell
        
        let thread = self.board.threads[indexPath.row]
        cell.threadNameLabel.text = thread.subject
        let firstPost = thread.posts.first
        if let firstPost = firstPost {
            cell.threadFirstPostLabel.text = firstPost.comment
            let fileModel = firstPost.files.first
            if let fileModel = fileModel {
                let imageUrl = NSURL(string: ServerManager.sharedInstance.urlForImage(self.board.id, path: fileModel.thumbPath!))
                cell.threadImage?.af_setImageWithURL(imageUrl!)
            }
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("toPosts", sender:indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100;
    }
}
