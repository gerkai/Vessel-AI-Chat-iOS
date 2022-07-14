//
//  OnboardingMVVMViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/13/22.
//

import UIKit

class OnboardingMVVMViewController: UIViewController
{
    var viewModel: OnboardingViewModel!
    
    func initWithViewModel(vm: OnboardingViewModel)
    {
        self.viewModel = vm
    }
}
