//
//  UIView+NetworkActivity.swift
//  CodingTask
//
//  Created by Suman Chatterjee on 23/04/23.
//

import Foundation
import UIKit

extension UIView {
    
    private var activityIndicatorTag: Int { return 999999 }
    private var activityIndicatorSuperViewTag: Int { return 888888 }


    public func showActivity(){
        let container = UIView(frame: self.frame)
        container.center = self.center
        container.tag = activityIndicatorSuperViewTag
        container.backgroundColor = UIColorFromHex(rgbValue: 0x000000, alpha: 0.4)
        self.addSubview(container)

        let loadingView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0))
        loadingView.center = container.center
        loadingView.backgroundColor = UIColorFromHex(rgbValue: 0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        container.addSubview(loadingView)

        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0))
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.tag = self.activityIndicatorTag
        activityIndicator.center =  CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2) //loadingView.center
        activityIndicator.hidesWhenStopped = true

        loadingView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
    }
    
    public func hideActivity() {
        if let conatinerView = self.allSubViews.filter(
            { $0.tag == self.activityIndicatorSuperViewTag}).first{

            if let activityIndicator = conatinerView.allSubViews.filter(
                { $0.tag == self.activityIndicatorTag}).first as? UIActivityIndicatorView {
                    activityIndicator.stopAnimating()
                    conatinerView.removeFromSuperview()
                }
        }
    }
    
    
    /*
     Define UIColor from hex value
     
     @param rgbValue - hex color value
     @param alpha - transparency level
     */
    private func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
}

extension UIView {
    var allSubViews : [UIView] {
        
        var array = [self.subviews].flatMap {$0}
        
        array.forEach { array.append(contentsOf: $0.allSubViews) }
        
        return array
    }
}
