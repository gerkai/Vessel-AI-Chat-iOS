//
//  TakeTestMVVMViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/13/22.
//

import UIKit

class TakeTestMVVMViewController: UIViewController, VesselScreenIdentifiable
{
    weak var viewModel: TakeTestViewModel!
    @Resolved internal var analytics: Analytics
    let flowName: AnalyticsFlowName = .takeTestFlow
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        print("📖 awake \(self)")
    }
    
    func initWithViewModel(vm: TakeTestViewModel)
    {
        self.viewModel = vm
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("📖 init \(self)")
        }
    }
    
    deinit
    {
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("📘 deinit \(self)")
        }
    }
}
