//
//  ScanningDropletsTipViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/19/22.
//

import UIKit

class ScanningDropletsTipViewController: TakeTestMVVMViewController, VesselScreenIdentifiable
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var hideTipSelectorView: SelectionCheckmarkView!
    
    @Resolved internal var analytics: Analytics
    let flowName: AnalyticsFlowName = .takeTestFlow
    
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
        viewModel.hideDropletTips(shouldHide: hideTipSelectorView.isChecked)
        let vc = viewModel.nextViewController()
        if (viewModel.curState == .Capture) && (UserDefaults.standard.bool(forKey: Constants.KEY_BYPASS_SCANNING) == true)
        {
            let storyboard = UIStoryboard(name: "AfterTest", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ResultsNavController") as! UINavigationController
            let root = vc.viewControllers[0] as! ResultsViewController
            root.mockTestResult()
            self.navigationController?.pushViewController(root, animated: true)
        }
        else
        {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
