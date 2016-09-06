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
    func setMediaViewerDelegate(delegate: MediaImageViewDelegate)
    func setMediaFile(thumbURL: NSURL, path: String, isWebm: Bool)
    func setQuotes(string: String)
    
    func setPushedAppearence()
}

class PostTableViewCell: UITableViewCell, PostCellProtocol {

    @IBOutlet weak var postImage: MediaImageView!
    
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var quotesTextView: UITextView!
    
    @IBOutlet weak var quotestLabel: UILabel!
    @IBOutlet weak var quotestHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.postImage.contentMode = UIViewContentMode.ScaleAspectFit
        self.postImage.clipsToBounds = true
        self.postTextView.linkTextAttributes = [NSForegroundColorAttributeName : UIColor.orangeColor()]
    }
    
    override func prepareForReuse() {
        self.postImage.image = nil
    }

    class func identifier() -> String {
        return "PostTableViewCellId"
    }
    
    class func nib() -> UINib {
        return UINib(nibName: "PostTableViewCell", bundle: NSBundle.mainBundle())
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
        self.postImage.mediaPath = path
        self.postImage.isWebm = isWebm
    }
    
    func setMediaViewerDelegate(delegate: MediaImageViewDelegate) {
        self.postImage.delegate = delegate
    }
    
    func setQuotes(string: String) {
        self.quotestLabel.text = string
    }
    
    func setPushedAppearence() {
        self.clipsToBounds = true
        self.backgroundColor = UIColor(red: 0.867, green: 0.867, blue: 0.867, alpha: 1.00)
        self.postTextView.backgroundColor = UIColor(red: 0.867, green: 0.867, blue: 0.867, alpha: 1.00)
        self.quotesTextView.backgroundColor = UIColor(red: 0.867, green: 0.867, blue: 0.867, alpha: 1.00)
        self.contentView.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.00).CGColor
        self.contentView.layer.borderWidth = 2
        self.layer.cornerRadius = 4
    }
}
