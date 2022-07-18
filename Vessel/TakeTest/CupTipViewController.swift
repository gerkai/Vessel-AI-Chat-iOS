//
//  CupTipViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/12/22.
//

import UIKit

class CupTipViewController: TakeTestMVVMViewController
{
    @IBOutlet weak var hideTipSelectorView: SelectionCheckmarkView!
    @IBOutlet weak var mainStackView: UIStackView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if view.frame.height >= Constants.SMALL_SCREEN_HEIGHT_THRESHOLD
        {
            mainStackView.spacing = 32.0
        }
        hideTipSelectorView.textLabel.text = Constants.DONT_SHOW_AGAIN_STRING
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        logPageViewed()
    }
    
    @IBAction func onBack()
    {
        self.navigationController?.fadeOut()
    }
    
    @IBAction func next()
    {
        if hideTipSelectorView.isChecked
        {
            viewModel.hideTips()
        }
        let vc = viewModel.nextViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
