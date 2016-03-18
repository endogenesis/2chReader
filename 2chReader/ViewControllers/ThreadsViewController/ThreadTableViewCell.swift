//
//  ThreadTableViewCell.swift
//  2chReader
//
//  Created by NIkolay Tsygankov on 3/14/16.
//  Copyright © 2016 Endogenesis. All rights reserved.
//

import UIKit

class ThreadTableViewCell: UITableViewCell {

    @IBOutlet weak var threadImage: UIImageView!
    
    @IBOutlet weak var threadNameLabel: UILabel!
    @IBOutlet weak var threadFirstPostLabel: UILabel!
    
    class func identifier() -> String {
        return "ThreadTableViewCellId"
    }
    
    class func nibThreadTableViewCell() -> UINib {
        return UINib(nibName: "ThreadTableViewCell", bundle: NSBundle.mainBundle())
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.threadImage.contentMode = UIViewContentMode.ScaleAspectFit
        self.threadImage.clipsToBounds = true
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func prepareForReuse() {
        self.threadImage.image = nil
        super.prepareForReuse()
    }
}
