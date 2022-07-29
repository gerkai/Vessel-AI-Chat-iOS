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
    
    var titleText: String!
    var details: String!
    var image: UIImage!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        titleLabel.text = titleText
        detailsLabel.text = details
        reagentImage.image = image
    }
    
    @IBAction func back()
    {
    }
    
    @IBAction func next()
    {
        if let vc = viewModel.nextViewController()
        {
            if vc.transition == .fade
            {
                navigationController?.fadeTo(vc)
            }
            else
            {
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        else
        {
            dismiss(animated: true)
        }
    }
}
