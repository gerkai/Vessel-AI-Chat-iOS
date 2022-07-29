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
    var transition: ScreenTransistion = .fade
    
    enum ScreenTransistion
    {
        case fade
        case push
    }
    
    func initWithViewModel(vm: AfterTestViewModel)
    {
        self.viewModel = vm
    }
    
    deinit
    {
        print("📘 deinit \(self)")
    }
}
