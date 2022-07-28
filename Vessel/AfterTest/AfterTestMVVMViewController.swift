//
//  AfterTestMVVMViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/28/22.
//

import UIKit

class AfterTestMVVMViewController: UIViewController
{
    weak var viewModel: AfterTestViewModel!
    
    func initWithViewModel(vm: AfterTestViewModel)
    {
        self.viewModel = vm
    }
    
    deinit
    {
        print("📘 deinit \(self)")
    }
}
