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
        print("📘 deinit \(self)")
    }
}
