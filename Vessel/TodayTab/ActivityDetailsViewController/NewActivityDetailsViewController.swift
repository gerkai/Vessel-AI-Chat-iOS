//
//  NewActivityDetailsViewController.swift
//  Vessel
//
//  Created by v.martin.peshevski on 21.8.23.
//

import UIKit
import Kingfisher

class NewActivityDetailsViewController: UIViewController, VesselScreenIdentifiable
{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var headerImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    
    @Resolved internal var analytics: Analytics
    let flowName: AnalyticsFlowName = .todayTabFlow
    var text: String = ""
    var imageUrl: String = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        headerImageView.kf.setImage(with: URL(string: imageUrl))
        subtitleLabel.text = text
    }
    
    // MARK: - Actions
    @IBAction func onBack()
    {
        navigationController?.popViewController(animated: true)
    }
}
