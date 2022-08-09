//
//  FMBlurable.swift
//  FMBlurable
//
//  Created by SIMON_NON_ADMIN on 18/09/2015.
//  Copyright © 2015 Simon Gladman. All rights reserved.
//
// Thanks to romainmenke (https://twitter.com/romainmenke) for hint on a larger sample...
// Github repo: https://github.com/FlexMonkey/Blurable
// Adapted by Nicolas Medina

import UIKit

protocol Blurable
{
    var layer: CALayer { get }
    var subviews: [UIView] { get }
    var frame: CGRect { get }
    var superview: UIView? { get }
    
    func addSubview(_ view: UIView)
    func removeFromSuperview()
    
    func blur(radius blurRadius: CGFloat)
    func unBlur()
    
    var isBlurred: Bool { get }
}

extension Blurable
{
    func blur(radius blurRadius: CGFloat)
    {
        guard let superview = self.superview,
              let rootViewController = UIApplication.shared.windows.first!.rootViewController else
        {
            return
        }
        
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.46
        rootViewController.view.addSubview(view)
        
        NSLayoutConstraint.activate([
            rootViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            rootViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0),
            rootViewController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0),
            rootViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0),
        ])
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: rootViewController.view.frame.width, height: rootViewController.view.frame.height), false, 1)
        
        rootViewController.view.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return }
        
        UIGraphicsEndImageContext();
        
        guard let blur = CIFilter(name: "CIGaussianBlur"),
              let this = self as? UIView else
        {
            return
        }
        
        blur.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        blur.setValue(blurRadius, forKey: kCIInputRadiusKey)
        
        let ciContext = CIContext(options: nil)
        
        let result = blur.value(forKey: kCIOutputImageKey) as! CIImage
        
        let boundingRect = CGRect(x: 0,
                                  y: 0,
                                  width: rootViewController.view.frame.width,
                                  height: rootViewController.view.frame.height)
        
        guard let cgImage = ciContext.createCGImage(result, from: boundingRect) else { return }
        
        let filteredImage = UIImage(cgImage: cgImage)
        
        let blurOverlay = BlurOverlay()
        blurOverlay.frame = CGRect(x: boundingRect.origin.x - 5,
                                   y: boundingRect.origin.y - 5,
                                   width: (boundingRect.size.width + 10),
                                   height: (boundingRect.size.height + 10))
        
        blurOverlay.image = filteredImage
        blurOverlay.contentMode = UIView.ContentMode.redraw
        
        if let index = (superview as UIView).subviews.firstIndex(of: this)
        {
            removeFromSuperview()
            superview.insertSubview(blurOverlay, at: index)
        }
        rootViewController.view.subviews.last?.removeFromSuperview()
        
        objc_setAssociatedObject(this,
                                 &BlurableKey.blurable,
                                 blurOverlay,
                                 objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
    
    func unBlur()
    {
        guard let this = self as? UIView,
              let blurOverlay = objc_getAssociatedObject(this, &BlurableKey.blurable) as? BlurOverlay else
        {
            return
        }
        
        if let superview = blurOverlay.superview,
           let index = superview.subviews.firstIndex(of: blurOverlay)
        {
            blurOverlay.removeFromSuperview()
            superview.insertSubview(this, at: index)
        }
        
        objc_setAssociatedObject(this,
                                 &BlurableKey.blurable,
                                 nil,
                                 objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
    
    var isBlurred: Bool
    {
        guard let this = self as? UIView else { return true }
        return objc_getAssociatedObject(this, &BlurableKey.blurable) is BlurOverlay
    }
}

extension UIView: Blurable
{
}

class BlurOverlay: UIImageView
{
}

struct BlurableKey
{
    static var blurable = "blurable"
}
