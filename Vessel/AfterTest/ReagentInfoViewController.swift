//
//  ReagentInfoViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/28/22.
//

import UIKit

class ReagentInfoViewController: AfterTestMVVMViewController, VesselScreenIdentifiable
{
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var detailsLabel: UILabel!
    @IBOutlet weak private var reagentImage: UIImageView!
    @IBOutlet weak private var progressAmount: NSLayoutConstraint!
    @IBOutlet weak private var progressView: UIView!
    @IBOutlet weak private var progressDot: UIImageView!
    
    var titleText: String!
    var details: String!
    var image: UIImage!
    
    @Resolved internal var analytics: Analytics
    let flowName: AnalyticsFlowName = .resultsTabFlow
    
    static func initWith(viewModel: AfterTestViewModel, result: AfterTestViewControllerData) -> ReagentInfoViewController
    {
        let storyboard = UIStoryboard(name: "AfterTest", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ReagentInfoViewController") as! ReagentInfoViewController
        vc.viewModel = viewModel
        vc.titleText = result.title
        vc.details = result.details
        vc.image = UIImage.init(named: result.imageName)
        
        return vc
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        titleLabel.text = titleText
        detailsLabel.text = details
        reagentImage.image = image
        
        //print("\(viewModel.currentScreen), \(viewModel.screens.count)")
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
