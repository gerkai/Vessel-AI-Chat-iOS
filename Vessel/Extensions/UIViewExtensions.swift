//
//  UIViewExtensions.swift
//  Vessel
//
//  Created by Carson Whitsett on 2/25/22.
//

import UIKit
import SwiftEntryKit

extension UIView
{
    static var nib: UINib
    {
        return UINib(nibName: self.className, bundle: nil)
    }
    
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
    
    static func showError(text: String, detailText: String, image: UIImage? = nil)
    {
        let textColor: EKColor = .white
        let backgroundUIColor: UIColor = UIColor(red: 243/255, green: 167/255, blue: 165/255, alpha: 1)
        let backgroundColor = EKColor(backgroundUIColor)
        // Generate top floating entry and set some properties
        var attributes = EKAttributes.topToast
        attributes.entryBackground = .color(color: backgroundColor)
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 10, offset: .zero))
        attributes.entranceAnimation = .init(scale: .init(from: 0.9, to: 1, duration: 0.4, spring: .init(damping: 1, initialVelocity: 0)), fade: .init(from: 0, to: 1, duration: 0.3))
        attributes.exitAnimation = .init(fade: .init(from: 1, to: 0, duration: 0.2))
        attributes.displayDuration = 3
        let title = EKProperty.LabelContent(text: text, style: .init(font: UIFont.systemFont(ofSize: 16.0, weight: .regular), color: textColor, alignment: .center))
        let description = EKProperty.LabelContent(text: detailText, style: .init(font: UIFont.systemFont(ofSize: 14, weight: .bold), color: textColor, alignment: .center))
        let simpleMessage: EKSimpleMessage
        if let image = image {
            let image = EKProperty.ImageContent(image: image, size: CGSize(width: 35, height: 35))
            simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
        } else {
            simpleMessage = EKSimpleMessage(image: nil, title: title, description: description)
        }
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        let contentView = EKNotificationMessageView(with: notificationMessage)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
    //hide / show stackView animation for UIViews inside stackviews
    func hideAnimated(in stackView: UIStackView)
    {
        if !self.isHidden
        {
            UIView.animate(
                withDuration: 0.35,
                delay: 0,
                usingSpringWithDamping: 0.9,
                initialSpringVelocity: 1,
                options: [],
                animations:
                {
                    self.isHidden = true
                    stackView.layoutIfNeeded()
                },
                completion: nil
            )
        }
    }

    func showAnimated(in stackView: UIStackView)
    {
        if self.isHidden
        {
            UIView.animate(
                withDuration: 0.35,
                delay: 0,
                usingSpringWithDamping: 0.9,
                initialSpringVelocity: 1,
                options: [],
                animations:
            {
                    self.isHidden = false
                    stackView.layoutIfNeeded()
                },
                completion: nil
            )
        }
    }
    
    func cutHalfCircle(with radius: CGFloat = 100)
    {
        //Borrowed from V2 app. Used for adding transparency border around Vessel button on home screen
        let center = CGPoint(x: UIScreen.main.bounds.midX, y: 0)
        let path = UIBezierPath(rect: bounds)
        path.addArc(withCenter: center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        let shiftingValue: CGFloat = 35
        let rightEdgePoint = CGPoint(x: center.x + shiftingValue, y: 0)
        path.move(to: rightEdgePoint)
        path.addCurve(to: CGPoint(x: rightEdgePoint.x, y: 2), controlPoint1: CGPoint(x: rightEdgePoint.x + 3, y: 0), controlPoint2: CGPoint(x: rightEdgePoint.x + 1, y: 0))
        let leftEdgePoint = CGPoint(x: center.x - shiftingValue, y: 0)
        path .move(to: leftEdgePoint)
        path.addCurve(to: CGPoint(x: leftEdgePoint.x, y: 2), controlPoint1: CGPoint(x: leftEdgePoint.x - 3, y: 0), controlPoint2: CGPoint(x: leftEdgePoint.x - 1, y: 0))
        let mask = CAShapeLayer()
        mask.fillRule = .evenOdd
        mask.path = path.cgPath
        layer.mask = mask
    }
}
