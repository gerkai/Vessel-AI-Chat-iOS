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
        
        //On devices with a safe area below (no home button), the tab bar icons are too close to the top of the tab bar.
        //this will move them down. Skip this for devices with home button (iPhone SE for example)
        /*
        if let window = UIApplication.shared.windows.first
        {
            let bottomPadding = window.safeAreaInsets.bottom
            
            if bottomPadding != 0
            {
                for vc in self.viewControllers!
                {
                    vc.tabBarItem.imageInsets = UIEdgeInsets(top: 9, left: 0, bottom: -9, right: 0)
                }
                tabBar.items?.forEach(
                    { $0.titlePositionAdjustment = UIOffset(horizontal: 10.0, vertical: 12.0)
                        print("Set tab bar item position")
                    })
            }
        }*/
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowImage = nil
        appearance.shadowColor = nil
        tabBar.standardAppearance = appearance
        
        if #available(iOS 15.0, *)
        {
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        }
        
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
    }
    
    deinit
    {
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("📘 deinit \(self)")
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
            self.tabBar.cutHalfCircle(with: 35)
            
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
        }
    }
    
    @objc func vesselButtonPressed()
    {
        /*
        let storyboard = UIStoryboard(name: "AfterTest", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ResultsNavController") as! UINavigationController
        let root = vc.viewControllers[0] as! ResultsViewController
        root.mockTestResult()
        //self.viewModel.uploadingFinished()
        //self.navigationController?.pushViewController(vc, animated: true)
        self.present(vc, animated: true)
        //self.navigationController?.pushViewController(vc, animated: true)
        */
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
    }
}
