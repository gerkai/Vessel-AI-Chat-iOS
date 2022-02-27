//
//  TestCardExistCheckingViewController.swift
//  vessel-ios
//
//  Created by Mohamed El-Taweel on 25/05/2021.
//  Copyright © 2021 Vessel Health Inc. All rights reserved.
//

import UIKit

class TestCardExistCheckingViewController: UIViewController
{

    
    @IBOutlet var testCardOptionsButtons: [UIButton]!
    @IBOutlet var testCardOptionsViewButtons: [UIButton]!
    @IBOutlet var testCardOptionsViews: [UIView]!
    //private lazy var analyticManager = AnalyticManager()

    private var selectedOption: Int? = nil
    var email: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var socialAuth: Bool = false

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
            UIView.showError(text: "Error", detailText: "Please Select Answer", image: nil)
            return
        }
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
 
        if selectedOption == 1
        {
            let vc = storyboard.instantiateViewController(identifier: "GiftedCardOnboardViewController") as! GiftedCardOnboardViewController
            vc.socialAuth = socialAuth
            vc.email = email
            vc.firstName = firstName
            vc.lastName = lastName
            //analyticManager.trackEvent(event: .SIGN_UP_TYPE_SELECTED(email: email, type: "SIGN UP GIFTED"))
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if selectedOption == 2
        {
            let vc = storyboard.instantiateViewController(identifier: "BoughtCardLoginViewController") as! BoughtCardLoginViewController
            vc.email = email
            //analyticManager.trackEvent(event: .SIGN_UP_TYPE_SELECTED(email: email, type: "SIGN UP BOUGHT ON WEB"))
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            let vc = storyboard.instantiateViewController(identifier: "NoTestCardOnboardViewController") as! NoTestCardOnboardViewController
            vc.email = email
            //analyticManager.trackEvent(event: .SIGN_UP_TYPE_SELECTED(email: email, type: "SIGN UP NO CARDS"))
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
