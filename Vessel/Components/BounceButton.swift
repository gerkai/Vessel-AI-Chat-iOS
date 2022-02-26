//
//  BounceButton.swift
//  Bloom
//
//  Created by Seth Sandler on 4/2/19.
//  Copyright © 2019 Bloom. All rights reserved.
//

import UIKit

public class BounceButton: UIButton
{

    private static let cornerRadius: CGFloat = 22.0
    
    @IBInspectable var scale: CGFloat = 0.95

    override public func awakeFromNib()
    {
        super.awakeFromNib()
        setupView()
    }

    override public func prepareForInterfaceBuilder()
    {
        super.prepareForInterfaceBuilder()
        setupView()
    }

    func setupView()
    {
        //Bind event handlers for the button
        addTarget(self, action: #selector(buttonDidClick), for: UIControl.Event.touchUpInside)
        addTarget(self, action: #selector(buttonDidTouchDown), for: [UIControl.Event.touchDown, UIControl.Event.touchDragEnter])
        addTarget(self, action: #selector(buttonDidCancel), for: [UIControl.Event.touchCancel, UIControl.Event.touchDragExit])
    }

    //------------------------------------------------------------------------------------------------------
    //Event Handling
    //------------------------------------------------------------------------------------------------------

    @objc
    func buttonDidTouchDown()
    {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [UIView.AnimationOptions.curveEaseOut, UIView.AnimationOptions.allowUserInteraction], animations:
        {
            self.layer.transform = CATransform3DMakeScale(self.scale, self.scale, 1)
        }, completion: nil)
    }

    @objc
    func buttonDidCancel()
    {
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [UIView.AnimationOptions.curveEaseOut, UIView.AnimationOptions.allowUserInteraction], animations:
        {
            self.layer.transform = CATransform3DIdentity
        }, completion: nil)
    }

    @objc
    func buttonDidClick()
    {
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [UIView.AnimationOptions.curveEaseOut, UIView.AnimationOptions.allowUserInteraction], animations:
        {
            self.layer.transform = CATransform3DIdentity
        }, completion: nil)
    }
}
