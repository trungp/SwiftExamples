//
//  LocalNotificationViewController.swift
//  SwiftExamples
//
//  Created by Trung Pham on 3/8/16.
//  Copyright © 2016 Trung Pham. All rights reserved.
//

import UIKit

class LocalNotificationViewController: UIViewController {
    
    @IBOutlet var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        button.addTarget(self, action: Selector("buttonAction"), forControlEvents: .TouchUpInside)
    }
    
    func buttonAction() {
        // If your app is already in the foreground, iOS does not show the notification.
        let notification = UILocalNotification()
        notification.fireDate = NSDate().dateByAddingTimeInterval(10)
        notification.alertBody = "Alert"
        notification.soundName = "Default"
        notification.alertTitle = "Sample notification"
        notification.userInfo = ["name": "John"]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
