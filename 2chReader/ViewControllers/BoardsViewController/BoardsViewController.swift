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
    
    var boards:[[Board]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let resManager = ResourceManager()
        self.boards = resManager.boards()
        
        self.tableView.registerNib(BoardsTableViewCell.nibBoardsTableViewCell(), forCellReuseIdentifier: BoardsTableViewCell.identifier())
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.boards.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.boards[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(BoardsTableViewCell.identifier(), forIndexPath: indexPath) as! BoardsTableViewCell
        
        let board = self.boards[indexPath.section][indexPath.row]
        
        board.name.characters.count
        cell.shortName.text = "/" + board.id
        cell.longName.text = board.name
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let board = self.boards[section].first!
        let headerForSection:String
        
        switch board.category! {
        case .Creation: headerForSection = "Creation"
        case .Games : headerForSection = "Games"
        case .HardwareSoft: headerForSection = "HardwareSoft"
        case .ThemeCentered: headerForSection = "ThemeCentered"
        case .None: headerForSection = "None"
        }
        
        return headerForSection
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("toThreads", sender:indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //MARK: -
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toThreads" {
            let vc = segue.destinationViewController as! ThreadsViewController
            let index = sender as! NSIndexPath
            let board = self.boards[index.section][index.row]
            vc.navigationItem.title = board.name
            vc.currentBoardID = board.id
        }
    }
}