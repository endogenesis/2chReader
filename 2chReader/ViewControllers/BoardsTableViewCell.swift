//
//  BoardsTableViewCell.swift
//  2chReader
//
//  Created by NIkolay Tsygankov on 2/2/16.
//  Copyright © 2016 Endogenesis. All rights reserved.
//

import UIKit

class BoardsTableViewCell: UITableViewCell {

    @IBOutlet weak var shortName: UILabel!
    @IBOutlet weak var longName: UILabel!
    
    class func identifier() -> String {
        return "BoardsTableViewCellId"
    }
    
    class func nibBoardsTableViewCell() -> UINib {
        return UINib(nibName: "BoardsTableViewCell", bundle: NSBundle.mainBundle())
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
