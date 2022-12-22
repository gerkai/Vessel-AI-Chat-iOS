//
//  MainTabBarController.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/11/22.
//

import UIKit

class MainTabBarController: UITabBarController
{
    var didLayout = false
    let vesselButtonIndex = 2
    let takeTestViewModel = TakeTestViewModel()
    private var vesselButton: BounceButton?
    @Resolved internal var analytics: Analytics
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("MainTabBarController did load")
        }
        //disable the tab bar's center button. We'll add our own.
        //(if we leave it enabled, user could tap below Vessel button and trigger a screen transition)
        tabBar.items![vesselButtonIndex].isEnabled = false
        
        setTabBarItemAppearance()
        
        //remove all prior viewControllers from the navigation stack which will cause them to be deallocated.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) //provide enough time for push/fade to complete
        {
            if let viewControllers = self.navigationController?.viewControllers
            {
                for vc in viewControllers
                {
                    if vc != self
                    {
                        vc.removeFromParent()
                    }
                }
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.selectTab(_:)), name: .selectTabNotification, object: nil)
    }
    
    func setTabBarItemAppearance()
    {
        let appearance = UITabBarItem.appearance()
        let attributes = [NSAttributedString.Key.font: UIFont(name: "BananaGrotesk-Regular", size: 16)]
        appearance.setTitleTextAttributes(attributes as [NSAttributedString.Key: Any], for: .normal)

        if #available(iOS 15.0, *)
        {
            let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            tabBarAppearance.compactInlineLayoutAppearance.normal.titleTextAttributes = attributes as [NSAttributedString.Key: Any]
            tabBarAppearance.inlineLayoutAppearance.normal.titleTextAttributes = attributes as [NSAttributedString.Key: Any]
            tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = attributes as [NSAttributedString.Key: Any]
        }
    }
    
    deinit
    {
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("📘 deinit \(self)")
        }
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func selectTab(_ notification: NSNotification)
    {
        if let tab = notification.userInfo?["tab"] as? Int
        {
            selectedIndex = tab
        }
    }
    
    override func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews()
        if didLayout == false
        {
            //only want to do this once
            didLayout = true
        
            //cut out the transparency around the Vessel button
            addCutout()
            
            //Unfortunately this cuts out the pixels of the center tab bar button so we won't use it. Instead, add a new BounceButton
            //and place it in the center of the tab bar. Attach action, pressed() which will programmatically switch the tab
            //bar to the correct index.
            
            let button = BounceButton()
            button.alpha = 0
            button.setImage(UIImage(named: "VesselButton"), for: .normal) //size is inhereted from the image
            button.scale = 1.2
            button.setupView()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(vesselButtonPressed), for: .touchUpInside)
            vesselButton = button

            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn)
            { [weak self] in
                guard let self = self else { return }
                self.vesselButton?.alpha = 1
            }
  
            view.addSubview(button)
            tabBar.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
            tabBar.topAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
            
            //if there have been no tests taken yet, default to the results tab
            var results: [Result] = Storage.retrieve(as: Result.self)
            if UserDefaults.standard.bool(forKey: Constants.KEY_USE_MOCK_RESULTS)
            {
                results = mockResults
            }
            if results.count == 0
            {
                self.selectedIndex = Constants.TAB_BAR_RESULTS_INDEX
            }
        }
    }
    
    func addCutout()
    {
        let centerButtonHeight = 58.0
        let padding = 10.0
        let shoulderRadius = 6.0
        
        let f = CGFloat(centerButtonHeight / 2.0) + padding
        let h = tabBar.frame.height
        let w = tabBar.frame.width
        let halfW = w / 2.0
        let path = UIBezierPath()
        path.move(to: .zero)
        
        //add line from left corner to left shoulder
        path.addLine(to: CGPoint(x: halfW - f - shoulderRadius, y: 0))
        
        //add the left shoulder
        path.addQuadCurve(to: CGPoint(x: halfW - f + 0.5, y: shoulderRadius), controlPoint: CGPoint(x: halfW - f, y: 0))
        
        //add the cutout
        path.addArc(withCenter: CGPoint(x: halfW, y: 0), radius: f, startAngle: .pi - 0.15, endAngle: 0.15, clockwise: false)
        
        //add the right shoulder
        path.addQuadCurve(to: CGPoint(x: halfW + f + shoulderRadius, y: 0), controlPoint: CGPoint(x: halfW + f, y: 0))
        
        //fill in the rest of the box
        path.addLine(to: CGPoint(x: w, y: 0))
        path.addLine(to: CGPoint(x: w, y: h))
        path.addLine(to: CGPoint(x: 0.0, y: h))
        
        let mask = CAShapeLayer()
        mask.fillRule = .evenOdd
        mask.path = path.cgPath
        tabBar.layer.mask = mask
    }
    
    @objc func vesselButtonPressed()
    {
        analytics.log(event: .vButtonTapped)
        if isWithinTestingWindow()
        {
            //allow enough time for Vessel button to finish animating
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2)
            {
                self.segueToNextVC()
            }
        }
        else
        {
            analytics.log(event: .dontForgetShown)
            GenericAlertViewController.presentAlert(in: self,
                                                    type: .imageTitleSubtitleHorizontalButtons(image: UIImage(named: "VesselButton")!,
                                                                                               title: GenericAlertLabelInfo(title: NSLocalizedString("Don't forget, test right after waking up.", comment: "")),
                                                                                               subtitle: GenericAlertLabelInfo(title: NSLocalizedString("For the most accurate results, test immediately after you wake up -- before you eat, drink, or exercise. If you've done any of these things, please test yourself tomorrow.", comment: ""),
                                                                                                                               alignment: .center,
                                                                                                                               height: 250),
                                                                                               buttons: [
                                                                                                GenericAlertButtonInfo(label: GenericAlertLabelInfo(title: NSLocalizedString("Cancel", comment: "")), type: .dark),
                                                                                                GenericAlertButtonInfo(label: GenericAlertLabelInfo(title: NSLocalizedString("Test Now", comment: "")), type: .clear)
                                                                                               ]),
                                                    background: .green,
                                                    delegate: self)
        }
    }
    
    func isWithinTestingWindow() -> Bool
    {
        //return true if we're currently inside the testing window (MORNING_TEST_TIME_START ~ MORNING_TEST_TIME_END)
        var timeExist: Bool
        let calendar = Calendar.current
        let startTimeComponent = DateComponents(calendar: calendar, hour: Constants.MORNING_TEST_TIME_START)
        let endTimeComponent   = DateComponents(calendar: calendar, hour: Constants.MORNING_TEST_TIME_END)

        let now = Date()
        let startOfToday = calendar.startOfDay(for: now)
        let startTime    = calendar.date(byAdding: startTimeComponent, to:
        startOfToday)!
        let endTime      = calendar.date(byAdding: endTimeComponent, to:
        startOfToday)!

        if startTime <= now && now <= endTime
        {
            timeExist = true
        }
        else
        {
            timeExist = false
        }
        return timeExist
    }
    
    func segueToNextVC()
    {
        //let vc = takeTestViewModel.nextViewController()
        //self.present(vc, animated: true)
        //jump straight to the intro video if user opted to not show tips. Otherwise, show tips
        if self.takeTestViewModel.shouldShowTips()
        {
            self.performSegue(withIdentifier: "TakeTestShowTipsSegue", sender: self)
        }
        else
        {
            takeTestViewModel.curState = .TestTips
            self.performSegue(withIdentifier: "TakeTestCaptureIntroSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "TakeTestShowTipsSegue"
        {
            takeTestViewModel.curState = .TestTips
            if let dest = segue.destination as? UINavigationController
            {
                let rootVC = dest.viewControllers.first as! TakeTestMVVMViewController
                rootVC.viewModel = takeTestViewModel
            }
        }
        if segue.identifier == "TakeTestCaptureIntroSegue"
        {
            takeTestViewModel.curState = .CaptureIntro
            if let dest = segue.destination as? UINavigationController
            {
                let rootVC = dest.viewControllers.first as! TakeTestMVVMViewController
                rootVC.viewModel = takeTestViewModel
            }
        }
    }
}

extension MainTabBarController: GenericAlertDelegate
{
    func onAlertButtonTapped(_ alert: GenericAlertViewController, index: Int, alertDescription: String)
    {
        if index == 1
        {
            DispatchQueue.main.async
            {
                self.segueToNextVC()
            }
        }
        else
        {
            analytics.log(event: .cancelButtonTapped)
        }
    }
}
