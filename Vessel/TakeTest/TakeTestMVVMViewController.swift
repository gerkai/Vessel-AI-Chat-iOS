//
//  TakeTestMVVMViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/13/22.
//

import UIKit

class TakeTestMVVMViewController: UIViewController
{
    var viewModel: TakeTestViewModel!
    
    init?(coder: NSCoder, viewModel: TakeTestViewModel)
    {
        print("TAKE TEST MVVM VC INIT CODER & VIEWMODEL")
        //self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder)
    {
        print("TAKE TEST MVVM VC INIT CODER")
        //viewModel = TakeTestViewModel()
        super.init(coder: coder)
    }
    
    func initWithViewModel(vm: TakeTestViewModel)
    {
        self.viewModel = vm
    }
}
