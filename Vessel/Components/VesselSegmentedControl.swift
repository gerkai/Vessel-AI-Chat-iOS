//
//  VesselSegmentedControl.swift
//  Vessel
//
//  Created by Carson Whitsett on 3/29/22.
//
//  Note this line in AppDelegate sets the white title text color:
//  UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)

import UIKit

class VesselSegmentedControl: UISegmentedControl
{
    override func layoutSubviews()
    {
        let segmentInset: CGFloat = 5       //inset amount
        let segmentImage: UIImage? = UIImage(color: Constants.DARK_GRAY_TRANSLUCENT)
        
        super.layoutSubviews()
        layer.cornerRadius = Constants.CORNER_RADIUS
        
        //foreground
        let foregroundIndex = numberOfSegments
        if subviews.indices.contains(foregroundIndex), let foregroundImageView = subviews[foregroundIndex] as? UIImageView
        {
            foregroundImageView.bounds = foregroundImageView.bounds.insetBy(dx: segmentInset, dy: segmentInset)
            foregroundImageView.image = segmentImage    //substitute with our own colored image
            foregroundImageView.layer.removeAnimation(forKey: "SelectionBounds")    //this removes the weird scaling animation
            foregroundImageView.layer.masksToBounds = true
            foregroundImageView.layer.cornerRadius = Constants.CORNER_RADIUS - 1
        }
    }
}

extension UIImage
{
    //creates a 1x1 UIImage given a UIColor
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1))
    {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
