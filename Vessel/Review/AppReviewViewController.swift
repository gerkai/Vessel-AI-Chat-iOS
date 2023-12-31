//
//  AppReviewViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 1/10/23.
//

import UIKit
import SafariServices

class AppReviewViewController: SlideupViewController, VesselScreenIdentifiable, SFSafariViewControllerDelegate
{
    @Resolved internal var analytics: Analytics
    let flowName: AnalyticsFlowName = .appReviewFlow
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("❇️ \(self)")
        }
    }
    
    deinit
    {
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("❌ \(self)")
        }
    }
    
    @IBAction func onAppReview()
    {
        //move these to Constants if we end up using them elsewhere in the app
        let appId = "1501275949"
        let urlStr = "https://itunes.apple.com/app/id\(appId)?action=write-review"
        self.openInSafari(url: urlStr, delegate: self)
        analytics.log(event: .appReviewGoToStore(value: true))
    }
    
    @IBAction func onNoThanks()
    {
        analytics.log(event: .appReviewGoToStore(value: false))
        dismissAnimation
        {
        }
    }
    
    // click top left "Done" button and dismissed
    func safariViewControllerDidFinish(_ controller: SFSafariViewController)
    {
        dismissAnimation
        {
        }
    }
        
      // swipe down and dismissed
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController)
    {
        dismissAnimation
        {
        }
    }
}
