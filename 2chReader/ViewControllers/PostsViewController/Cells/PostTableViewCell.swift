//
//  PostTableViewCell.swift
//  2chReader
//
//  Created by Nikolay Tsygankov on 3/19/16.
//  Copyright © 2016 Endogenesis. All rights reserved.
//

import UIKit
import AlamofireImage

protocol PostCellProtocol {
    func setComment(string: String)
    func setAttributedComment(attrString: NSAttributedString)
    func setTextViewDelegate(delegate: UITextViewDelegate)
    func setMediaViewerDelegate(delegate: PostCellMediaDelegate)
    func setMediaFile(thumbURL: NSURL, path: String, isWebm: Bool)
    func setQuotes(string: String)
}

protocol PostCellMediaDelegate: class {
    func playWebm(path: String)
   // func showFullImage()
}

class PostTableViewCell: UITableViewCell, PostCellProtocol {
    
    weak var mediaViewer: PostCellMediaDelegate? = nil

    //TODO: Create subclassOfImageView with eventHandler
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var quotesTextView: UITextView!
    
    @IBOutlet weak var quotestLabel: UILabel!
    @IBOutlet weak var quotestHeight: NSLayoutConstraint!
    
    var mediaFilePath: String? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.postImage.contentMode = UIViewContentMode.ScaleAspectFit
        self.postImage.clipsToBounds = true
        self.postTextView.linkTextAttributes = [NSForegroundColorAttributeName : UIColor.orangeColor()]
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PostTableViewCell.imageViewTapped))
        gestureRecognizer.numberOfTapsRequired = 1
        self.postImage.addGestureRecognizer(gestureRecognizer)
    }
    
    override func prepareForReuse() {
        self.postImage.image = nil
        self.mediaFilePath = nil
    }

    class func identifier() -> String {
        return "PostTableViewCellId"
    }
    
    class func nib() -> UINib {
        return UINib(nibName: "PostTableViewCell", bundle: NSBundle.mainBundle())
    }
    
    //MARK: Action
    
    func imageViewTapped() {
        if let mediaFilePath = self.mediaFilePath {
            self.mediaViewer?.playWebm(mediaFilePath)
        }
    }
    
    //MARK: PostCellProtocol
    
    func setComment(string: String) {
        self.postTextView.text = string
    }
    
    func setAttributedComment(attrString: NSAttributedString) {
        self.postTextView.attributedText = attrString
    }
    
    func setTextViewDelegate(delegate: UITextViewDelegate) {
        self.postTextView.delegate = delegate
    }
    
    func setMediaFile(thumbURL: NSURL, path: String, isWebm: Bool) {
        self.postImage.af_setImageWithURL(thumbURL)
        self.mediaFilePath = path
        if isWebm {
            let playImageView = UIImageView(image: UIImage(named: "playVideo"))
            playImageView.frame.size.height = 20
            playImageView.frame.size.width = 20
            self.postImage.addSubview(playImageView)
            playImageView.center = self.postImage.center
        }
    }
    
    func setMediaViewerDelegate(delegate: PostCellMediaDelegate) {
        self.mediaViewer = delegate
    }
    
    func setQuotes(string: String) {
        self.quotestLabel.text = string
    }
}
