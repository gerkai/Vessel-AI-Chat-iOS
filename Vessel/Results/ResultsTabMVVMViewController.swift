//
//  ResultsTabMVVMViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 9/24/22.
//
import UIKit

class ResultsTabMVVMViewController: UIViewController
{
    weak var viewModel: ResultsTabViewModel!
    
    func initWithViewModel(vm: ResultsTabViewModel)
    {
        self.viewModel = vm
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("❇️ \(self)")
        }
    }
    
    deinit
    {
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("❌ \(self)")
        }
    }
}
