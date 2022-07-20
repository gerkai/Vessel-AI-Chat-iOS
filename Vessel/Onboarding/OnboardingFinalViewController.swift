//
//  OnboardingFinalViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/10/22.
//

import UIKit

class OnboardingFinalViewController: OnboardingMVVMViewController
{
    @IBOutlet weak var titleLabel: UILabel!
        
    override func viewDidLoad()
    {
        titleLabel.text = viewModel?.finalScreenText()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        // TODO: Add analytics for viewed page
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
