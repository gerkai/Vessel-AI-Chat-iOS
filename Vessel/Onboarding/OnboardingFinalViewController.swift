//
//  OnboardingFinalViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/10/22.
//

import UIKit

class OnboardingFinalViewController: UIViewController
{
    @IBOutlet weak var titleLabel: UILabel!
    
    var viewModel: OnboardingViewModel?
    
    override func viewDidLoad()
    {
        titleLabel.text = viewModel?.finalScreenText()
    }
    
    @IBAction func onBackButtonPressed()
    {
        viewModel?.backup()
        self.navigationController?.fadeOut()
    }
    
    @IBAction func onNextButtonPressed()
    {
        let vc = OnboardingViewModel.NextViewController()
        navigationController?.fadeTo(vc)
    }
}