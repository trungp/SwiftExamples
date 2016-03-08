//
//  NSURLSessionDownloadViewController.swift
//  SwiftExamples
//
//  Created by Trung Pham on 3/8/16.
//  Copyright © 2016 Trung Pham. All rights reserved.
//

import UIKit

class NSURLSessionDownloadViewController: UIViewController, NSURLSessionDownloadDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var refreshWithDelegateButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    
    var session: NSURLSession?
    var task: NSURLSessionDownloadTask?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Init and config session
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.allowsCellularAccess = true
        configuration.HTTPMaximumConnectionsPerHost = 1
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        
        // Init session
        session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func refreshButtonAction(sender: AnyObject) {
        
        let isRefresh = refreshWithDelegateButton.titleLabel?.text == "Refresh"
        if isRefresh {
            refreshWithDelegateButton.setTitle("Pause", forState: .Normal)
            
            // Cancel current task
            if let task = task {
                task.resume()
            } else {
                // Init task and download
                let imageUrl = NSURL(string: "https://wallpaperscraft.com/image/girl_long-haired_look_pretty_79305_3840x2160.jpg")
                guard let downloadUrl = imageUrl else { return }
                // Init task with url
                task = session?.downloadTaskWithURL(downloadUrl)
                
                // Start the task
                if let task = task {
                    task.resume()
                }
            }
            
        } else {
            refreshWithDelegateButton.setTitle("Refresh", forState: .Normal)
            
            // Pause current task
            if let task = task {
                task.suspend()
            }
        }
    }

    // MARK: NSURLSessionDownloadDelegate
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        
        // finish download
        let imageData = NSData(contentsOfURL: location)
        if let imageData = imageData {
            let downloadedImage = UIImage(data: imageData)
            
            // Update image
            runOnMainThread() { [weak self] in
                guard let this = self else { return }
                this.imageView.image = downloadedImage
            }
        }
        
        // Clear task
        task = nil
    }
    
    /* Sent periodically to notify the delegate of download progress. */
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        // Update progres on UI
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        runOnMainThread() { [weak self] in
            guard let this = self else { return }
            this.progressView.progress = progress
        }
    }
    
    /* Sent when a download has been resumed. If a download failed with an
    * error, the -userInfo dictionary of the error will contain an
    * NSURLSessionDownloadTaskResumeData key, whose value is the resume
    * data.
    */
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
    }
}
