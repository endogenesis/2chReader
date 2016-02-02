//
//  BoardsViewController.swift
//  2chReader
//
//  Created by NIkolay Tsygankov on 2/2/16.
//  Copyright © 2016 Endogenesis. All rights reserved.
//

import UIKit


class BoardsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var boards:[Board] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let resManager = ResourceManager()
        self.boards = resManager.boards()
        
        self.tableView.registerNib(BoardsTableViewCell.nibBoardsTableViewCell(), forCellReuseIdentifier: BoardsTableViewCell.identifier())
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boards.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(BoardsTableViewCell.identifier(), forIndexPath: indexPath) as! BoardsTableViewCell
        
        let board = self.boards[indexPath.row]
        
        cell.shortName.text = board.id
        cell.longName.text = board.name
        
        return cell
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
