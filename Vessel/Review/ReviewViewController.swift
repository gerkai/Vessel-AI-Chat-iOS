//
//  ReviewViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 2023-01-10.
//  Copyright © 2023 Vessel Health Inc. All rights reserved.
//

import UIKit

class ReviewViewController: SlideupViewController, VesselScreenIdentifiable
{
    @Resolved internal var analytics: Analytics
    let flowName: AnalyticsFlowName = .appReviewFlow
    
    enum ReviewStatus
    {
        case BAD
        case NORMAL
        case HAPPY
    }

    var review: ReviewStatus?
    var parentVC: UIViewController!
    var originalSubmitColor: UIColor!

    @IBOutlet var reviewButtons: [UIButton]!
    @IBOutlet weak var submitButton: BounceButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        originalSubmitColor = submitButton.backgroundColor
        submitButton.backgroundColor = Constants.vesselGray
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
    
    @IBAction func onCloseButtonTapped()
    {
        //reset launch date so user will be prompted again at the next interval
        UserDefaults.standard.set(Date(), forKey: Constants.KEY_FIRST_LAUNCH_DATE)
        dismissAnimation
        {
        }
    }
    
    @IBAction func onLowReviewButtonTapped(_ sender: UIButton)
    {
        enableSubmitButton()
        reviewButtons.forEach{ $0.isSelected = false }
        sender.isSelected = true
        review = .BAD
    }
    
    @IBAction func onNormalReviewButtonTapped(_ sender: UIButton)
    {
        enableSubmitButton()
        reviewButtons.forEach{ $0.isSelected = false }
        sender.isSelected = true
        review = .NORMAL
    }
    
    @IBAction func onHighReviewButtonTapped(_ sender: UIButton)
    {
        enableSubmitButton()
        reviewButtons.forEach{ $0.isSelected = false }
        sender.isSelected = true
        review = .HAPPY
    }
    
    func enableSubmitButton()
    {
        submitButton.isEnabled = true
        submitButton.backgroundColor = originalSubmitColor
    }
    
    @IBAction func onSubmitButtonTapped(_ sender: Any)
    {
        if let userReview = review
        {
            switch userReview
            {
                case .BAD:
                    analytics.log(event: .appReviewFeedback(text: "sad"))
                    giveFeedback()
                case .NORMAL:
                analytics.log(event: .appReviewFeedback(text: "meh"))
                    giveFeedback()
                case .HAPPY:
                    //set flag that indicates contact has reviewed app experience
                    let contact = Contact.main()!
                    contact.flags |= Constants.HAS_RATED_APP
                    ObjectStore.shared.clientSave(contact)
                    
                    //we don't need launch date in user defaults anymore.
                    UserDefaults.standard.removeObject(forKey: Constants.KEY_FIRST_LAUNCH_DATE)
                    analytics.log(event: .appReviewFeedback(text: "happy"))
                    reviewApp()
            }
        }
    }
    
    func reviewApp()
    {
        dismissAnimation
        {
            let storyboard = UIStoryboard(name: "Review", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AppReviewViewController") as! AppReviewViewController
            self.parentVC.present(vc, animated: false)
        }
    }
    
    func giveFeedback()
    {
        dismissAnimation
        {
            let storyboard = UIStoryboard(name: "Review", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "FeedbackViewController") as! FeedbackViewController
            self.parentVC.present(vc, animated: false)
        }
    }
}

