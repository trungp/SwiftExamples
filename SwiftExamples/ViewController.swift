//
//  ViewController.swift
//  SwiftExamples
//
//  Created by Trung Pham on 3/7/16.
//  Copyright © 2016 Trung Pham. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    
    var tableData: [[String]]? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        tableData = [[String]]()
        tableData!.append(["AlertController", "Main", "AlertControllerSampleViewController"])
        tableData!.append(["Calendar", "Main", "CalendarViewController"])
        tableData!.append(["NSURLSession", "NSURLSessionViewController", "NSURLSessionViewController"])
        tableData!.append(["NSURLSessionDownload", "NSURLSessionDownloadViewController", "NSURLSessionDownloadViewController"])
        tableData!.append(["Local Notification", "LocalNotificationViewController", "LocalNotificationViewController"])
        
        
        
    }

    // MARK: UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = tableData![indexPath.row][0]
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let viewController = UIStoryboard.viewController(tableData![indexPath.row][1], identitifer: tableData![indexPath.row][2])
        guard let vc = viewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }

}

