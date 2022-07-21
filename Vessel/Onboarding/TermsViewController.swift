//
//  TermsViewController.swift
//  vessel-ios
//
//  Created by Carson Whitsett on 2022-07-10.
//  Copyright © 2021 Vessel Health Inc. All rights reserved.
//

import UIKit

class TermsViewController: OnboardingMVVMViewController, UIScrollViewDelegate
{
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var allowNextButton = false
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        // TODO: Add analytics for viewed page
    }
    
    override func viewDidLayoutSubviews()
    {
        if scrollView.isAtBottom
        {
            allowNextButton = true
        }
        else
        {
            allowNextButton = false
        }
        updateNextButton()
    }
    
    @IBAction func onBackButtonPressed(_ sender: Any)
    {
        viewModel?.backup()
        self.navigationController?.fadeOut()
    }
    
    @IBAction func onNextButtonTapped()
    {
        if allowNextButton
        {
            let vc = OnboardingViewModel.NextViewController()
            navigationController?.fadeTo(vc)
        }
        else
        {
            UIView.showError(text: "", detailText: NSLocalizedString("Please read the entire disclaimer", comment: "Error message when user hasn't yet made a selection"), image: nil)
        }
    }
    
    func updateNextButton()
    {
        if allowNextButton == true
        {
            nextButton.backgroundColor = Constants.vesselBlack
        }
        else
        {
            nextButton.backgroundColor = Constants.vesselGray
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {    
        if scrollView.isAtBottom
        {
            if allowNextButton == false
            {
                allowNextButton = true
                updateNextButton()
            }
        }
    }
}
