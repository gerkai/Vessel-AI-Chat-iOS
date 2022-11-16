//
//  WaterDetailsViewController.swift
//  Vessel
//
//  Created by Nicolas Medina on 10/1/22.
//

import UIKit

class WaterDetailsViewController: UIViewController, VesselScreenIdentifiable
{
    // MARK: - Views
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var waterIntakeView: WaterIntakeView!
    
    // MARK: - Model
    var numberOfGlasses: Int = 2
    var drinkedWaterGlasses: Int = 0
    var waterIntakeViewDelegate: WaterIntakeViewDelegate?
    
    @Resolved internal var analytics: Analytics
    let flowName: AnalyticsFlowName = .todayTabFlow
    
    // MARK: - UIViewController Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        waterIntakeView.numberOfGlasses = numberOfGlasses
        waterIntakeView.checkedGlasses = drinkedWaterGlasses
        waterIntakeView.delegate = waterIntakeViewDelegate
        subtitleLabel.text = NSLocalizedString("\(waterIntakeView.numberOfGlasses * 8) oz daily", comment: "Daily water intake")
    }
    
    // MARK: - Actions
    @IBAction func onBack()
    {
        navigationController?.popViewController(animated: true)
    }
}

extension WaterDetailsViewController: UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if scrollView.contentOffset.y <= 0
        {
            view.backgroundColor = .backgroundGreen
        }
        else
        {
            view.backgroundColor = .codGray
        }
    }
}
