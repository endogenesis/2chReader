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
    @IBOutlet weak var labelComment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.postImage.contentMode = UIViewContentMode.ScaleAspectFit
        self.postImage.clipsToBounds = true
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
}
