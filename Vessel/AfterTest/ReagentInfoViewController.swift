//
//  ReagentInfoViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/28/22.
//

import UIKit

class ReagentInfoViewController: AfterTestMVVMViewController
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var reagentImage: UIImageView!
    @IBOutlet weak var progressAmount: NSLayoutConstraint!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressDot: UIImageView!
    
    var titleText: String!
    var details: String!
    var image: UIImage!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        titleLabel.text = titleText
        detailsLabel.text = details
        reagentImage.image = image
        
        print("\(viewModel.currentScreen), \(viewModel.screens.count)")
        if viewModel.screens.count >= 2
        {
            let percentage = CGFloat(viewModel.currentScreen) / CGFloat(viewModel.screens.count - 1)
            progressAmount.constant = progressView.frame.size.width * percentage
        }
        else
        {
            //hide progressView if there is only 1 screen
            progressView.alpha = 0.0
        }
    }
    
    @IBAction func onBackButton()
    {
        back()
    }
    
    @IBAction func next()
    {
        nextScreen()
    }
}
