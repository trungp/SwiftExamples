//
//  FaceDetectorViewController.swift
//  SwiftExamples
//
//  Created by Trung Pham on 3/8/16.
//  Copyright © 2016 Trung Pham. All rights reserved.
//

import UIKit

class FaceDetectorViewController: UIViewController {
    
    var imageView: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Show image view
        imageView = UIImageView(image: UIImage(named: "monkeys.jpg"))
        view.addSubview(imageView!)
        
        let rightBarButtonItem = UIBarButtonItem(title: "Detect", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("detectBarButtonItem"))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func detectBarButtonItem() {
        
        let filePath = NSBundle.mainBundle().pathForResource("monkeys", ofType: "jpg")
        guard let imageFilePath = filePath else { return }
        let imageUrl = NSURL.fileURLWithPath(imageFilePath)
        guard let ciImage = CIImage(contentsOfURL: imageUrl) else { return }
        
        let ciContext = CIContext(options: nil)
        let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let detector = CIDetector(ofType: CIDetectorTypeFace, context: ciContext, options: options)
        
        // detect the features
        let features = detector.featuresInImage(ciImage, options: [CIDetectorSmile: true, CIDetectorEyeBlink: true]) as NSArray
        
        // Auxiliar view to invert later
        let vistAux = UIView(frame: imageView!.frame)
        self.view.addSubview(vistAux)
        
        for faceFeature in features {
            // Add face location
            let faceRect = faceFeature.bounds
            
            // Init faceView and add to auxiliar view
            let faceView = UIView(frame: faceRect)
            faceView.layer.borderWidth = 1
            faceView.layer.borderColor = UIColor.redColor().CGColor
            vistAux.addSubview(faceView)
            
            // get width & height of face
            let faceWidth = CGRectGetWidth(faceRect)
            let faceHeight = CGRectGetHeight(faceRect)
            
            // Check the detection
            let smile = faceFeature.hasSmile!
            let rightEyeBlinking = faceFeature.rightEyeClosed!
            let leftEyeBlinking = faceFeature.leftEyeClosed!
            
            // Draw smile position
            if smile {
                let smileView = UIView(frame: CGRectMake(faceFeature.mouthPosition.x - faceWidth * 0.18, faceFeature.mouthPosition.y - faceHeight*0.1, faceWidth * 0.4, faceHeight * 0.2))
                smileView.layer.cornerRadius = faceWidth * 0.1
                smileView.layer.borderWidth = 1
                smileView.layer.borderColor = UIColor.greenColor().CGColor
                smileView.alpha = 0.4
                vistAux.addSubview(smileView)
            }
            
            // Draw eyes position
            let rightEyeView = UIView(frame: CGRectMake(faceFeature.rightEyePosition.x-faceWidth*0.2, faceFeature.rightEyePosition.y-faceWidth*0.2, faceWidth*0.4, faceWidth*0.4))
            rightEyeView.layer.cornerRadius = faceWidth*0.2
            rightEyeView.layer.borderWidth = 2
            rightEyeView.layer.borderColor = UIColor.redColor().CGColor
            if rightEyeBlinking {
                rightEyeView.layer.backgroundColor = UIColor.yellowColor().CGColor
            } else {
                rightEyeView.layer.backgroundColor = UIColor.redColor().CGColor
            }
            rightEyeView.layer.opacity = 0.5
            vistAux.addSubview(rightEyeView)
            
            let leftEyeView = UIView(frame: CGRectMake(faceFeature.leftEyePosition.x-faceWidth*0.2, faceFeature.leftEyePosition.y-faceWidth*0.2, faceWidth*0.4, faceWidth*0.4))
            leftEyeView.layer.cornerRadius = faceWidth*0.2
            leftEyeView.layer.borderWidth = 2
            leftEyeView.layer.borderColor = UIColor.redColor().CGColor
            if leftEyeBlinking {
                leftEyeView.layer.backgroundColor = UIColor.yellowColor().CGColor
            } else {
                leftEyeView.layer.backgroundColor = UIColor.redColor().CGColor
            }
            leftEyeView.layer.opacity = 0.5
            vistAux.addSubview(leftEyeView)
        }
        
        //Invert coords
        vistAux.transform = CGAffineTransformMakeScale(1, -1)
    }
}
