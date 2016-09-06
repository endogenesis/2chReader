//
//  PostsViewController.swift
//  2chReader
//
//  Created by NIkolay Tsygankov on 3/14/16.
//  Copyright © 2016 Endogenesis. All rights reserved.
//

import UIKit
import RealmSwift
import OGVKit


class PostsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, OGVPlayerDelegate, MediaImageViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var thread: Thread = Thread()
    var board: BoardRealm = BoardRealm()
    var pushedPosts: [UIView] = []
    
    let attrStrBuilder = AttributedStringBuilder()
    
    let webmView: OGVPlayerView = OGVPlayerView()
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(PostTableViewCell.nib(), forCellReuseIdentifier: PostTableViewCell.identifier())
        
        self.tableView.registerNib(SimplePostTableViewCell.nib(), forCellReuseIdentifier: SimplePostTableViewCell.identifier())
        
        self.tableView.registerNib(ManyPhotosTableViewCell.nib(), forCellReuseIdentifier: ManyPhotosTableViewCell.identifier())
        
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
        
        self.webmView.frame = self.view.bounds
        
       
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
        let post: Post = self.thread.posts[indexPath.row]
        let identifier = self.cellIdentifierWithPost(post)
        
        let cell :PostCellProtocol = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! PostCellProtocol
        
        cell.setAttributedComment(self.attrStrBuilder.attributedString(post.comment!)!)
        //cell.setAttributedComment(self.attrStrBuilder.mimicAttrStr(post.comment!)!)
        cell.setTextViewDelegate(self)
        cell.setMediaViewerDelegate(self)
        for file in post.files {
            let isWebm = file.fileModelType == .FileModelWebm ? true : false
            cell.setMediaFile(NSURL(string: ServerManager.sharedInstance.urlForImage(self.board.id, path: file.thumbPath!))!, path: file.fullImagePath!, isWebm: isWebm)
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
        post.comment = "Ух бля помню с корешем вдвоём проходили по сетке ебать нам это тогда казалось верхом прогресса, как же интересно было"
        self.pushPostOnScreen(post)
        return false
    }
    
    // MARK: - MediaImageViewDelegate
    
    func showWebm(path: String) {
        
        view.addSubview(self.webmView)
        self.addHideWebmButton()
        
        self.webmView.delegate = self; // implement OGVPlayerDelegate protocol
        self.webmView.sourceURL = NSURL(string: ServerManager.sharedInstance.urlForImage(self.board.id, path: path))!
        
        self.webmView.play()
    }
    
    func addHideWebmButton() {
        let hideWebmButton = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: #selector(PostsViewController.onStopWebmClicked))
        self.navigationItem.rightBarButtonItem = hideWebmButton
    }
    
    func onStopWebmClicked() {
        self.navigationItem.rightBarButtonItem = nil
        self.webmView.pause()
        self.webmView.sourceURL = nil
        self.webmView.removeFromSuperview()
    }
    
    // MARK: - Pushed PostView
    
    func pushPostOnScreen(post: Post) {
        let cell = NSBundle.mainBundle().loadNibNamed(self.nibNameWithPost(post), owner: nil, options: nil)[0] as! PostCellProtocol
        
        if let comment = post.comment {
            cell.setAttributedComment(self.attrStrBuilder.attributedString(comment)!)
            cell.setTextViewDelegate(self)
        }
        for file in post.files {
            let isWebm: Bool = file.fileModelType == .FileModelWebm ? true : false
            cell.setMediaFile(NSURL(string: ServerManager.sharedInstance.urlForImage(self.board.id, path: file.thumbPath!))!, path: file.fullImagePath!, isWebm: isWebm)
        }
        cell.setPushedAppearence()
        
        let viewCell = cell as! UITableViewCell
        viewCell.hidden = true
        self.pushedPosts.append(viewCell)
        self.setFrameForPushedPost(viewCell)
        self.view.addSubview(viewCell)
        
        dispatch_async(dispatch_get_main_queue()) { 
            UIView.transitionWithView(viewCell, duration: 0.4, options: [.CurveEaseOut, .TransitionFlipFromBottom], animations: {
                viewCell.hidden = false
                }, completion: nil)
        }

    }
    
    func popPostFromScreen() {
        let postOnScreen = self.pushedPosts.last
        if let postOnScreen = postOnScreen {
            UIView.transitionWithView(postOnScreen, duration: 0.3, options: [.CurveEaseOut, .TransitionFlipFromTop], animations: { 
                postOnScreen.hidden = true
                }, completion: { _ in
                    postOnScreen.removeFromSuperview()
            })
            
            self.pushedPosts.removeLast()
        }
    }
    
    func setFrameForPushedPost(view: UIView) {
        var fittingSize = UILayoutFittingCompressedSize
        let offset: CGFloat = CGFloat(self.pushedPosts.indexOf(view)! * 10)
        fittingSize.width = CGRectGetWidth(self.view.frame) - 2 * offset - 20
        view.frame.size = view.systemLayoutSizeFittingSize(fittingSize, withHorizontalFittingPriority: UILayoutPriorityRequired, verticalFittingPriority: UILayoutPriorityDefaultLow)
        print(view.frame.size)
        
        var centerPost = self.view.center
        centerPost.y += CGFloat(offset)
        
        view.center = centerPost
    }
    
    //MARK: Utils
    
    func cellIdentifierWithPost(post: Post) -> String {
        switch post.type {
        case .NoImagePost:
            return SimplePostTableViewCell.identifier()
        case .OneImagePost:
            return PostTableViewCell.identifier()
        case .ManyImagePost:
            return ManyPhotosTableViewCell.identifier()
        }
    }
    
    func nibNameWithPost(post: Post) -> String {
        switch post.type {
        case .NoImagePost:
            return "SimplePostTableViewCell"
        case .OneImagePost:
            return "PostTableViewCell"
        case .ManyImagePost:
            return "ManyPhotosTableViewCell"
        }
    }
}
