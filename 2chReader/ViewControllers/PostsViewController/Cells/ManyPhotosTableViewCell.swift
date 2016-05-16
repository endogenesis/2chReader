//
//  ManyPhotosTableViewCell.swift
//  2chReader
//
//  Created by NIkolay Tsygankov on 5/3/16.
//  Copyright © 2016 Endogenesis. All rights reserved.
//

import UIKit

class ManyPhotosTableViewCell: UITableViewCell, PostCellProtocol {
    
    weak var mediaViewer: PostCellMediaDelegate? = nil

    @IBOutlet var files: [UIImageView]!
    var mediaFilePaths: [String] = []
    var imageViewToLoadNext = 0
    
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var quotesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        for imageView in self.files {
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            imageView.clipsToBounds = true
        }
        
        self.postTextView.linkTextAttributes = [NSForegroundColorAttributeName : UIColor.orangeColor()]
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        self.quotesLabel.text = nil
        
        for imageView in self.files {
            imageView.image = nil
        }
        self.imageViewToLoadNext = 0
    }
    
    class func identifier() -> String {
        return "ManyPhotosTableViewCellId"
    }
    
    class func nib() -> UINib {
        return UINib(nibName: "ManyPhotosTableViewCell", bundle: NSBundle.mainBundle())
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
        //debug
        if self.imageViewToLoadNext > 3 {
            print("fileModel count in post more than 4")
        }
        self.files[self.imageViewToLoadNext].af_setImageWithURL(thumbURL)
        self.mediaFilePaths.append(path)
        if isWebm {
            let playImageView = UIImageView(image: UIImage(named: "playVideo"))
            self.files[self.imageViewToLoadNext].addSubview(playImageView)
            playImageView.center = self.files[self.imageViewToLoadNext].center
        }
        self.imageViewToLoadNext += 1
    }
    
    func setMediaViewerDelegate(delegate: PostCellMediaDelegate) {
        self.mediaViewer = delegate
    }
    
    func setQuotes(string: String) {
        self.quotesLabel.text = string
    }

}
