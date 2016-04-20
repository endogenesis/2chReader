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
    func loadImage(imageURL: NSURL)
}

class PostTableViewCell: UITableViewCell, PostCellProtocol {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var quotesTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.postImage.contentMode = UIViewContentMode.ScaleAspectFit
        self.postImage.clipsToBounds = true
        self.postTextView.linkTextAttributes = [NSForegroundColorAttributeName : UIColor.orangeColor()]
        self.quotesTextView.linkTextAttributes = [NSForegroundColorAttributeName : UIColor.orangeColor()]
    }
    
    override func prepareForReuse() {
        self.postImage.image = nil
    }

    class func identifier() -> String {
        return "PostTableViewCellId"
    }
    
    class func nibPostTableViewCell() -> UINib {
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
    
    func loadImage(imageURL: NSURL) {
        self.postImage.af_setImageWithURL(imageURL)
    }
}
