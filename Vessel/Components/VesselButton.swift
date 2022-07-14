//
//  VesselButton.swift
//  vessel-ios
//
//  Created by Carson Whitsett on 3/5/2022.
//  Copyright © 2022 Vessel Health Inc. All rights reserved.
//

import UIKit

class VesselButton: BounceButton
{
    override func layoutSubviews()
    {
        //position imageView on right side of button, inset the same distance the title is from the left side.
        super.layoutSubviews()
        //determine title inset
        if let horizInset = titleLabel?.frame.origin.x
        {
            if let imageSize = imageView?.bounds.size
            {
                imageView?.frame = CGRect(
                    x: bounds.width - imageSize.width - horizInset,
                    y: (bounds.height / 2 - imageSize.height / 2),
                    width: imageSize.width,
                    height: imageSize.height)   
            }
        }
    }
}
