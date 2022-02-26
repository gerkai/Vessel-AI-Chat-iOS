//
//  UIViewExtensions.swift
//  Vessel
//
//  Created by Carson Whitsett on 2/25/22.
//

import UIKit
extension UIView
{
    func pushTransition(_ duration:CFTimeInterval)
    {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.type = CATransitionType.push
        animation.subtype = CATransitionSubtype.fromBottom
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.push.rawValue)
    }
    
    func fadeIn(duration: TimeInterval = 1.0)
    {
        UIView.animate(withDuration: duration, animations:
        {
           self.alpha = 1.0
        })
    }

    func fadeOut(duration: TimeInterval = 1.0)
    {
        UIView.animate(withDuration: duration, animations:
        {
           self.alpha = 0.0
        })
    }
}
