//
//  TakeTestMVVMViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/13/22.
//

import UIKit

class TakeTestMVVMViewController: UIViewController
{
    weak var viewModel: TakeTestViewModel!
    
    func initWithViewModel(vm: TakeTestViewModel)
    {
        self.viewModel = vm
    }
    
    deinit
    {
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("📘 deinit \(self)")
        }
    }
}
