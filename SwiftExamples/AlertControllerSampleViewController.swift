//
//  AlertControllerSampleViewController.swift
//  SwiftExamples
//
//  Created by Trung Pham on 3/7/16.
//  Copyright © 2016 Trung Pham. All rights reserved.
//

import UIKit

class AlertControllerSampleViewController: UIViewController {

    @IBAction func showAlert(sender: AnyObject) {
        let alertController = UIAlertController(title: "Alert", message: "Do you want to close the Alert box?", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Close", style: .Default) { action in
            self.dismissViewControllerAnimated(true) {}
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel) { action in
            self.dismissViewControllerAnimated(true) {}
        })
        presentViewController(alertController, animated: true) {}
    }
    
    @IBAction func showActionSheet(sender: AnyObject) {
        let alertController = UIAlertController(title: "ActionSheet", message: "Tap to close to close actionSheet?", preferredStyle: .ActionSheet)
        alertController.addAction(UIAlertAction(title: "Close", style: .Default) { action in
            self.dismissViewControllerAnimated(true) {}
            })
        alertController.addAction(UIAlertAction(title: "Delete", style: .Destructive) { action in
            self.dismissViewControllerAnimated(true) {}
            })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel) { action in
            self.dismissViewControllerAnimated(true) {}
            })
        presentViewController(alertController, animated: true) {}
    }
    
    @IBAction func showCustomAlert(sender: AnyObject) {
        let alertController = UIAlertController(title: "ActionSheet", message: "Tap to close to close actionSheet?", preferredStyle: .Alert)
        
        alertController.addAction(UIAlertAction(title: "Close", style: .Default) { action in
            self.dismissViewControllerAnimated(true) {}
            })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel) { action in
            self.dismissViewControllerAnimated(true) {}
            })
        
        alertController.addTextFieldWithConfigurationHandler({(textField:
            UITextField!) in
            textField.placeholder = "Enter your name"
        })
        alertController.addTextFieldWithConfigurationHandler({(textField:
            UITextField!) in
            textField.placeholder = "Enter your job"
        })
        
        presentViewController(alertController, animated: true) {}
    }
}
