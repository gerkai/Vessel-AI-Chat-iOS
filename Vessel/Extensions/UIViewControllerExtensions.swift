//
//  UIViewControllerExtensions.swift
//  Vessel
//
//  Created by Carson Whitsett on 2/25/22.
//

import UIKit
import SafariServices

private var associationKey: UInt8 = 0

extension UIViewController
{
    var displayWindow: UIWindow?
    {
        get
        {
            return objc_getAssociatedObject(self, &associationKey) as? UIWindow
        }

        set(newValue)
        {
            objc_setAssociatedObject(self, &associationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var mainTabBarController: MainTabBarController?
    {
        if let mainTabBarController = UIApplication.shared.windows.first?.rootViewController as? MainTabBarController
        {
            return mainTabBarController
        }
        else if let navigationController = UIApplication.shared.windows.first?.rootViewController as? UINavigationController,
              let mainTabBarController = navigationController.topViewController as? MainTabBarController
        {
            return mainTabBarController
        }
        return nil
    }
    
    func openInSafari(url: String)
    {
        if let url = URL(string: url)
        {
            let vc = SFSafariViewController(url: url)
            vc.modalPresentationStyle = .overCurrentContext
            present(vc, animated: true)
        }
    }
    
    func showOverTopViewController(presentationStyle: UIModalPresentationStyle = .overCurrentContext, modalTransition: UIModalTransitionStyle = .coverVertical)
    {
        let topWindow = UIApplication.shared.windows.last
        if topWindow?.rootViewController is OverTopViewController
        {
            //return
            print("WOULD HAVE RETURNED HERE")
        }
        self.displayWindow = UIWindow.init(frame: UIScreen.main.bounds)
        displayWindow?.rootViewController?.view.backgroundColor = .clear
        let viewController = OverTopViewController()
        viewController.view.backgroundColor = .clear
        self.displayWindow?.rootViewController = viewController

        if let topWindow = topWindow
        {
            self.displayWindow?.windowLevel = topWindow.windowLevel + 1
        }

        self.modalPresentationStyle = presentationStyle
        self.modalTransitionStyle = modalTransition
        self.displayWindow?.makeKeyAndVisible()
        self.displayWindow?.rootViewController?.present(self, animated: true, completion: nil)
    }
}

class OverTopViewController: UIViewController
{
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        displayWindow?.isHidden = true
        displayWindow = nil
    }
}
