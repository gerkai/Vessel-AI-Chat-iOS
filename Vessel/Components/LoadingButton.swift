//
//  LoadingButton.swift
//  Bloom
//
//  Created by Seth Sandler on 3/25/19.
//  Copyright © 2019 Bloom. All rights reserved.
//

import UIKit

class LoadingButton: VesselButton
{
    var originalButtonText: String?
    var originalButtonImage: UIImage?

    var activityIndicator: UIActivityIndicatorView!

    @IBInspectable
    let activityIndicatorColor: UIColor = .lightGray

    func showLoading()
    {
        isUserInteractionEnabled = false
        originalButtonText = self.titleLabel?.text
        originalButtonImage = self.imageView?.image
        setTitle("", for: .normal)
        setImage(nil, for: .normal)
        if (activityIndicator == nil)
        {
            activityIndicator = createActivityIndicator()
        }
        showSpinning()
    }

    func hideLoading()
    {
        isUserInteractionEnabled = true
        setTitle(originalButtonText, for: .normal)
        setImage(originalButtonImage, for: .normal)
        activityIndicator?.stopAnimating()
    }

    private func createActivityIndicator() -> UIActivityIndicatorView
    {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = activityIndicatorColor
        return activityIndicator
    }

    private func showSpinning()
    {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }

    private func centerActivityIndicatorInButton()
    {
        let xCenterConstraint = NSLayoutConstraint(item: self,
                                                   attribute: .centerX,
                                                   relatedBy: .equal,
                                                   toItem: activityIndicator,
                                                   attribute: .centerX,
                                                   multiplier: 1, constant: 0)
        addConstraint(xCenterConstraint)

        let yCenterConstraint = NSLayoutConstraint(item: self,
                                                   attribute: .centerY,
                                                   relatedBy: .equal,
                                                   toItem: activityIndicator,
                                                   attribute: .centerY,
                                                   multiplier: 1, constant: 0)
        addConstraint(yCenterConstraint)
    }
}
