//
//  TestCardExistCheckingViewController.swift
//  vessel-ios
//
//  Created by Carson Whitsett on 3/26/2022
//  Copyright © 2022 Vessel Health Inc. All rights reserved.
//  Based on Login Flow: https://www.notion.so/vesselhealth/Login-2dbc7f76cf4c4953abd8b4aa7bc34bc5

import UIKit

class TestCardExistCheckingViewController: UIViewController
{
    @IBOutlet var testCardOptionsButtons: [UIButton]!
    @IBOutlet var testCardOptionsViewButtons: [UIButton]!
    @IBOutlet var testCardOptionsViews: [UIView]!
    @Resolved private var analytics: Analytics

    private var selectedOption: Int? = nil

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        logPageViewed()
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
            UIView.showError(text: "Error", detailText: "Please Select Answer", image: nil)
            return
        }
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
 
        if selectedOption == 1
        {
            let vc = storyboard.instantiateViewController(identifier: "BoughtCardLoginViewController") as! BoughtCardLoginViewController
            analytics.log(event: .identification, properties: ["Type": "Purchased"])
            self.navigationController?.fadeTo(vc)
        }
        else if selectedOption == 2
        {
            let vc = storyboard.instantiateViewController(identifier: "GiftedCardOnboardViewController") as! GiftedCardOnboardViewController
            analytics.log(event: .identification, properties: ["Type": "Gifted"])
            self.navigationController?.fadeTo(vc)
        }
        else
        {
            let vc = storyboard.instantiateViewController(identifier: "NoTestCardOnboardViewController") as! NoTestCardOnboardViewController
            analytics.log(event: .identification, properties: ["Type": "Dont Have Yet"])
            self.navigationController?.fadeTo(vc)
        }
    }
}
