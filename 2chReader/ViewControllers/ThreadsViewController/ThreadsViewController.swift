//
//  ThreadsViewController.swift
//  2chReader
//
//  Created by NIkolay Tsygankov on 2/5/16.
//  Copyright © 2016 Endogenesis. All rights reserved.
//

import UIKit
import RealmSwift

class ThreadsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentBoard: String = ""
    var threads :[Thread] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "id")

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        let realm = try! Realm()
       // self.threads = realm.objects(Thread).filter("age < 2")
        ServerManager.sharedInstance.threadsFromBoard(self.currentBoard, page: 0) { (threads) -> Void in
            self.threads = threads!
            try! realm.write {
                realm.add(self.threads, update:true)
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return threads.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("id", forIndexPath: indexPath) 
        
        let thread = self.threads[indexPath.row]
        cell.textLabel?.text = thread.subject
        return cell
    }

}
