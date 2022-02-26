//
//  VesselButton.swift
//  vessel-ios
//
//  Created by Paul Wong on 4/19/20.
//  Copyright © 2020 Vessel Health Inc. All rights reserved.
//

import UIKit

class VesselButton: BounceButton
{

    private static let cornerRadius: CGFloat = 22.0
    private static let padding: CGFloat = 30.0

    override func setupView()
    {
        super.setupView()
        
        layer.cornerRadius = VesselButton.cornerRadius
        
        if let imageView = imageView, imageView.image != nil
        {
            // only set title insets if there is an image
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 20.0, bottom: 0, right: 0)
        }
    }
    
    public override func imageRect(forContentRect contentRect: CGRect) -> CGRect
    {
        var imageFrame = super.imageRect(forContentRect: contentRect)
        imageFrame.origin.x = bounds.maxX - imageFrame.width - VesselButton.padding
        return imageFrame
    }
}
