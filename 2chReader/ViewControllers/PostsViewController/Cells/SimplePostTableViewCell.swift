//
//  SimplePostTableViewCell.swift
//  2chReader
//
//  Created by NIkolay Tsygankov on 4/21/16.
//  Copyright © 2016 Endogenesis. All rights reserved.
//

import UIKit

class SimplePostTableViewCell: UITableViewCell, PostCellProtocol {

    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var quotesTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.postTextView.linkTextAttributes = [NSForegroundColorAttributeName : UIColor.orangeColor()]
        self.quotesTextView.linkTextAttributes = [NSForegroundColorAttributeName : UIColor.orangeColor()]
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func identifier() -> String {
        return "SimplePostTableViewCellId"
    }
    
    class func nibPostTableViewCell() -> UINib {
        return UINib(nibName: "SimplePostTableViewCell", bundle: NSBundle.mainBundle())
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
        print("without image")
    }
    
}
