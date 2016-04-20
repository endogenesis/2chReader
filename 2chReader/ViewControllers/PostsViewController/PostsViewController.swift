//
//  PostsViewController.swift
//  2chReader
//
//  Created by NIkolay Tsygankov on 3/14/16.
//  Copyright © 2016 Endogenesis. All rights reserved.
//

import UIKit
import RealmSwift

class PostsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var thread: Thread = Thread()
    var board: BoardRealm = BoardRealm()
    var pushedPosts: Array<UIView> = Array()
    
    let attrStrBuilder = AttributedStringBuilder()
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(PostTableViewCell.nibPostTableViewCell(), forCellReuseIdentifier: PostTableViewCell.identifier())
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.navigationItem.title = self.thread.subject
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(PostsViewController.onTapEvent))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    func onTapEvent() {
        self.popPostFromScreen()
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        for view in self.pushedPosts {
            self.setFrameForPushedPost(view)
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
        
        let cell :PostCellProtocol = tableView.dequeueReusableCellWithIdentifier(PostTableViewCell.identifier(), forIndexPath: indexPath) as! PostCellProtocol
        
        let post: Post = self.thread.posts[indexPath.row]
        
        cell.setComment(post.comment!)
        let fileModel = post.files.first
        if let fileModel = fileModel {
        cell.loadImage(NSURL(string: ServerManager.sharedInstance.urlForImage(self.board.id, path: fileModel.thumbPath!))!)
        }
        return cell as! UITableViewCell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100;
    }
    
    // MARK: - UITextViewDelegate
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        // 1) get Post
        let post = Post()
        post.comment = "feswfwef ewfwef efwf ewf ewf ewf ew ffwefwefwef fewfwe "
        self.pushPostOnScreen(post)
        return false
    }
    
    // MARK: - Other
    
    func pushPostOnScreen(post: Post) {
        let cell = NSBundle.mainBundle().loadNibNamed("PostTableViewCell", owner: nil, options: nil)[0] as! PostTableViewCell
        if let comment = post.comment {
            cell.postTextView.attributedText = self.attrStrBuilder.attributedString(comment)
            cell.postTextView.delegate = self
        }
        
        let fileModel = post.files.first
        if let fileModel = fileModel {
            let imageUrl = NSURL(string: ServerManager.sharedInstance.urlForImage(self.board.id, path: fileModel.thumbPath!))
            cell.postImage?.af_setImageWithURL(imageUrl!)
        }
        self.view.addSubview(cell)
        self.pushedPosts.append(cell)
        self.setFrameForPushedPost(cell)
        cell.backgroundColor = UIColor.cyanColor()
        cell.contentView.layer.borderColor = UIColor.grayColor().CGColor
        cell.contentView.layer.borderWidth = 2
    }
    
    func popPostFromScreen() {
        let postOnScreen = self.pushedPosts.last
        if let postOnScreen = postOnScreen {
            postOnScreen.removeFromSuperview()
            self.pushedPosts.removeLast()
        }
    }
    
    func setFrameForPushedPost(view: UIView) {
        var fittingSize = UILayoutFittingCompressedSize
        let offset: CGFloat = CGFloat(self.pushedPosts.indexOf(view)! * 10)
        fittingSize.width = CGRectGetWidth(self.view.frame) - 2 * offset
        view.frame.size = view.systemLayoutSizeFittingSize(fittingSize, withHorizontalFittingPriority: UILayoutPriorityRequired, verticalFittingPriority: UILayoutPriorityDefaultLow)
        print(view.frame.size)
        var centerPost = self.view.center
        centerPost.y += CGFloat(offset)
        //centerPost.x += CGFloat(offset)
        view.center = centerPost
    }
}
