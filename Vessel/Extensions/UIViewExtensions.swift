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
    
    func shake(count : Float = 4, for duration : TimeInterval = 0.25, withTranslation translation : Float = 5) {
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.repeatCount = count
        animation.duration = duration/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: CGFloat(-translation), y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: CGFloat(translation), y: self.center.y))
        layer.add(animation, forKey: "shake")
    }
}
