//
//  UINavigationControllerExtensions.swift
//  Vessel
//
//  Created by Carson Whitsett on 2/25/22.
//

import UIKit

extension UINavigationController
{
    func fadeTo(_ viewController: UIViewController)
    {
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        view.layer.add(transition, forKey: nil)
        pushViewController(viewController, animated: false)
    }
    
    func fadeOut()
    {
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        view.layer.add(transition, forKey: nil)
        popViewController(animated: false)
    }
}
