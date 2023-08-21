//
//  NewActivityDetailsViewController.swift
//  Vessel
//
//  Created by v.martin.peshevski on 21.8.23.
//

import UIKit

class NewActivityDetailsViewController: UIViewController, VesselScreenIdentifiable
{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var headerImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    
    @Resolved internal var analytics: Analytics
    let flowName: AnalyticsFlowName = .todayTabFlow
    
    // MARK: - Actions
    @IBAction func onBack()
    {
        navigationController?.popViewController(animated: true)
    }
}
