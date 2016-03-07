//
//  UIKitExtension.swift
//  SwiftUtils
//
//  Created by Trung Pham on 2/17/16.
//  Copyright © 2016 Trung Pham. All rights reserved.
//

import UIKit
import Foundation

extension UIStoryboard {
    
    // Initialize story with name
    static func storyBoardForName(name: String) -> UIStoryboard? {
        return UIStoryboard(name: name, bundle: nil)
    }
    
    // Initialize story with name & bundle
    static func storyBoardForName(name: String, bundle: NSBundle) -> UIStoryboard? {
        return UIStoryboard(name: name, bundle: bundle)
    }
    
    // Instantiate view controller from storyboard
    static func viewController(storyboard: String, identitifer: String) -> UIViewController? {
        guard let storyboard = storyBoardForName(storyboard) else { return nil }
        return storyboard.instantiateViewControllerWithIdentifier(identitifer)
    }
    
    // Instantiate view controller from storyboard
    static func viewController(storyboard: String, bundle: NSBundle, identitifer: String) -> UIViewController? {
        guard let storyboard = storyBoardForName(storyboard, bundle: bundle) else { return nil }
        return storyboard.instantiateViewControllerWithIdentifier(identitifer)
    }
}

extension UIView {
    
    static func viewFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
        let nib = UINib(nibName: nibNamed, bundle: bundle)
        return nib.instantiateWithOwner(nil, options: nil)[0] as? UIView
    }

    // Add corner radius for view
    func cornerRadius(radius: CGFloat) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
    
    
    func boxShadow(radius radius: CGFloat, offset: CGSize, color: UIColor) {
        let shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: 7)
        layer.masksToBounds = false
        layer.shadowColor = color.CGColor
        layer.shadowOffset = offset
        layer.shadowOpacity = 0.5
        layer.shadowPath = shadowPath.CGPath
    }
    
    func borderStyleWithColor(color: UIColor, width: CGFloat) {
        layer.borderColor = color.CGColor
        layer.borderWidth = width
    }
    
    func gradientBackground(topColor topColor: UIColor, bottomColor: UIColor, topRatio: CGFloat, bottomRatio: CGFloat) {
        let gl = CAGradientLayer()
        gl.colors = [topColor.CGColor, bottomColor.CGColor]
        gl.locations = [topRatio, bottomRatio]
        gl.frame = bounds
        layer.insertSublayer(gl, atIndex: 0)
    }
    
}

func delay(delay: Double, closure: ()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(),
        closure
    )
}

func runOnMainThread(closure: ()->()) {
    dispatch_async(dispatch_get_main_queue(), closure)
}