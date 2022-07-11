//
//  MainViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/11/22.
//

import UIKit

class MainViewController: UITabBarController
{
    var didLayout = false
    let vesselButtonIndex = 2
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //disable the tab bar's center button. We'll add our own.
        //(if we leave it enabled, user could tap below Vessel button and trigger a screen transition)
        tabBar.items![vesselButtonIndex].isEnabled = false
    }
    
    override func viewWillLayoutSubviews()
    {
        if didLayout == false
        {
            //only want to do this once
            didLayout = true
        
            //cut out the transparency around the Vessel button
            self.tabBar.cutHalfCircle(with: 35)
            
            //Unfortunately this cuts out the pixels of the center tab bar button so we won't use it. Instead, add a new BounceButton
            //and place it in the center of the tab bar. Attach action, pressed() which will programmatically switch the tab
            //bar to the correct index.
            
            let button = BounceButton()
            button.setImage(UIImage(named: "VesselButton"), for: .normal) //size is inhereted from the image
            button.scale = 1.2
            button.setupView()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(pressed), for: .touchUpInside)
            
            view.addSubview(button)
            tabBar.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
            tabBar.topAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        }
    }
    
    @objc func pressed()
    {
        selectedIndex = vesselButtonIndex
    }
}
