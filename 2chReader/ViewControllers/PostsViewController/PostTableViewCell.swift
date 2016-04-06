//
//  PostTableViewCell.swift
//  2chReader
//
//  Created by Nikolay Tsygankov on 3/19/16.
//  Copyright © 2016 Endogenesis. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var quotesTextView: UITextView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.postImage.contentMode = UIViewContentMode.ScaleAspectFit
        self.postImage.clipsToBounds = true
        self.postTextView.linkTextAttributes = [NSForegroundColorAttributeName : UIColor.orangeColor()]
    }
    
    override func prepareForReuse() {
        self.postImage.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.quotesTextView.text.characters.count < 5 {
            self.heightConstraint.constant = 0
        } else {
            self.heightConstraint.constant = 20
        }
    }

    class func identifier() -> String {
        return "PostTableViewCellId"
    }
    
    class func nibPostTableViewCell() -> UINib {
        return UINib(nibName: "PostTableViewCell", bundle: NSBundle.mainBundle())
    }
}
