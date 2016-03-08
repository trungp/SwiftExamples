//
//  NSURLSessionViewController.swift
//  SwiftExamples
//
//  Created by Trung Pham on 3/8/16.
//  Copyright © 2016 Trung Pham. All rights reserved.
//

import UIKit

class NSURLSessionViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func refreshButtonAction(sender: AnyObject) {
        loadWeatherData()
    }
    
    private func loadWeatherData() {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        // Allow mobile data
        configuration.allowsCellularAccess = true
        
        // Accept json
        configuration.HTTPAdditionalHeaders = ["Accept" : "application/json"]
        
        // timeout
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        configuration.HTTPMaximumConnectionsPerHost = 1
        
        // Init session
        let session = NSURLSession(configuration: configuration)
        session.dataTaskWithURL(NSURL(string: "http://api.openweathermap.org/data/2.5/weather?q=London&appid=bb1e8a878a0cf3f36da09a8a244a45ae")!) { [weak self] (data, response, error) in
            guard let this = self else { return }
            guard let data = data else {
                if let error = error {
                    print("Error: ", error.localizedDescription)
                }
                return
            }
            
            // Convert data to json
            do {
                let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                if jsonObject.count == 0 {
                    return
                }
                guard let dict = jsonObject as? [String: AnyObject] else { return }
                runOnMainThread() {
                    this.updateDataOnView(dict)
                }
            } catch {
                print("exception")
            }
            }.resume() // Start the session
    }
    
    private func updateDataOnView(dict: [String: AnyObject]?) {
        if let dict = dict {
            textView.text = dict.description
        }
    }
}
