//
//  TestCardExistCheckingViewController.swift
//  vessel-ios
//
//  Created by Carson Whitsett on 3/26/2022
//  Copyright © 2022 Vessel Health Inc. All rights reserved.
//  Based on Login Flow: https://www.notion.so/vesselhealth/Login-2dbc7f76cf4c4953abd8b4aa7bc34bc5

import UIKit

class TestCardExistCheckingViewController: UIViewController, VesselScreenIdentifiable
{
    @IBOutlet var testCardOptionsButtons: [UIButton]!
    @IBOutlet var testCardOptionsViewButtons: [UIButton]!
    @IBOutlet var testCardOptionsViews: [UIView]!
    
    @Resolved internal var analytics: Analytics
    let flowName: AnalyticsFlowName = .loginFlow

    private var selectedOption: Int? = nil

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBAction func onOptionButtonTapped(_ sender: UIButton)
    {
        testCardOptionsButtons.forEach{ $0.isSelected = false }
        testCardOptionsViews.forEach{ $0.backgroundColor = UIColor.white.withAlphaComponent(0.4) }
        sender.isSelected = !sender.isSelected
        testCardOptionsViews[sender.tag - 1].backgroundColor = .whiteAlpha7
        selectedOption = sender.tag
    }
    
    @IBAction func onOptionViewButtonTapped(_ sender: UIButton)
    {
        testCardOptionsButtons.forEach{ $0.isSelected = false }
        testCardOptionsViews.forEach{ $0.backgroundColor = UIColor.white.withAlphaComponent(0.4) }
        testCardOptionsButtons[sender.tag - 1].isSelected = !sender.isSelected
        testCardOptionsViews[sender.tag - 1].backgroundColor = .whiteAlpha7
        selectedOption = sender.tag
    }
    
    @IBAction func onBackButtonTapped(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onContinueButtonTapped(_ sender: Any)
    {
        onboardUser()
    }
    
    private func onboardUser()
    {
        guard let selectedOption = selectedOption else
        {
            UIView.showError(text: "", detailText: "Please select answer", image: nil)
            return
        }
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
 
        if selectedOption == 1
        {
            if Contact.PractitionerID == nil
            {
                let vc = storyboard.instantiateViewController(identifier: "BoughtCardLoginViewController") as! BoughtCardLoginViewController
                analytics.log(event: .identification(type: .purchased))
                self.navigationController?.fadeTo(vc)
            }
            else
            {
                navToGiftedOrCoordinator()
            }
        }
        else if selectedOption == 2
        {
            navToGiftedOrCoordinator()
        }
        else
        {
            let vc = storyboard.instantiateViewController(identifier: "NoTestCardOnboardViewController") as! NoTestCardOnboardViewController
            analytics.log(event: .identification(type: .dontHaveYet))
            self.navigationController?.fadeTo(vc)
        }
    }
    
    func navToGiftedOrCoordinator()
    {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        if Contact.main() != nil
        {
            //if the contact already exists (due to social login, we can go straight to Onboarding (or contact cleanup)
            LoginCoordinator.shared.pushLastViewController(to: navigationController)
        }
        else
        {
            let vc = storyboard.instantiateViewController(identifier: "GiftedCardRegisterViewController") as! GiftedCardRegisterViewController
            self.navigationController?.fadeTo(vc)
        }
    }
}
