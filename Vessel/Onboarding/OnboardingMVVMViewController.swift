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
    
    override func viewDidLoad()
    {
        print("📗 did load \(self)")
    }
    
    func initWithViewModel(vm: OnboardingViewModel)
    {
        self.viewModel = vm
        print("📗 init \(self)")
    }
    
    deinit
    {
        print("📘 deinit \(self)")
    }
}
