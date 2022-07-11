//
//  MainViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/11/22.
//

import UIKit

class MainViewController: UITabBarController
{
    //@IBOutlet weak var tabBar: UITabBar!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tabBar.cutHalfCircle(with: 35)
        
        var frame = tabBar.bounds
        let safeAreaHeight = safeAreaInsets.bottom
        frame.size.height = frame.size.height + safeAreaHeight
        tabBar.setNeedsLayout()
    }
    
    public var safeAreaInsets: UIEdgeInsets
    {
        guard let window: UIWindow = UIApplication.shared.windows.first else
        {
            return .zero
        }
        return window.safeAreaInsets
    }
}
