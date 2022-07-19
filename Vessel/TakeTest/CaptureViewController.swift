//
//  CaptureViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/19/22.
//

import UIKit

class CaptureViewController: TakeTestMVVMViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBAction func onBackButton()
    {
        viewModel.curState.back()
        navigationController?.popViewController(animated: true)
    }
}
