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
    
    @IBOutlet weak var quotesLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.postTextView.linkTextAttributes = [NSForegroundColorAttributeName : UIColor.orangeColor()]
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func prepareForReuse() {
        self.quotesLabel.text = nil
    }
    
    class func identifier() -> String {
        return "SimplePostTableViewCellId"
    }
    
    class func nib() -> UINib {
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
    
    func setMediaFile(thumbURL: NSURL, path: String, isWebm: Bool) {
    }
    
    func setMediaViewerDelegate(delegate: MediaImageViewDelegate) {
    }
    
    func setQuotes(string: String) {
        self.quotesLabel.text = string
    }
    
    func setPushedAppearence() {
        self.clipsToBounds = true
        self.backgroundColor = UIColor(red: 0.867, green: 0.867, blue: 0.867, alpha: 1.00)
        self.postTextView.backgroundColor = UIColor(red: 0.867, green: 0.867, blue: 0.867, alpha: 1.00)
        self.quotesLabel.backgroundColor = UIColor(red: 0.867, green: 0.867, blue: 0.867, alpha: 1.00)
        self.contentView.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.00).CGColor
        self.contentView.layer.borderWidth = 2
        self.layer.cornerRadius = 4
    }
    
}
