//
//  ScanningDropletsTipViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/19/22.
//

import UIKit

class ScanningDropletsTipViewController: TakeTestMVVMViewController
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var hideTipSelectorView: SelectionCheckmarkView!
    
    override func viewDidLoad()
    {
        //disable wonky orphaned word prevention (started with iOS 11)
        titleLabel.lineBreakStrategy = []
        hideTipSelectorView.textLabel.text = Constants.DONT_SHOW_AGAIN_STRING
        super.viewDidLoad()
    }
    
    @IBAction func onBackButton()
    {
        viewModel.curState.back()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButton()
    {
        if hideTipSelectorView.isChecked
        {
            viewModel.hideDropletTips()
        }
        let vc = viewModel.nextViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
