//
//  ActivityDetailsViewController.swift
//  Vessel
//
//  Created by Nicolas Medina on 10/5/22.
//

import UIKit
import Kingfisher

class ActivityDetailsViewController: UIViewController, VesselScreenIdentifiable
{
    // MARK: - Views
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var headerImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var reagentsLabel: UILabel?
    @IBOutlet private weak var quantitiesLabel: UILabel?
    @IBOutlet private weak var reagentsStackView: UIStackView?
    
    @Resolved internal var analytics: Analytics
    let flowName: AnalyticsFlowName = .todayTabFlow
    
    // MARK: - Model
    private var viewModel: ActivityDetailsViewModel?
    
    // MARK: - UIViewController Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        if scrollView.frame.height - scrollView.contentSize.height > 0
        {
            view.backgroundColor = .codGray
        }
    }
    
    // MARK: - Initialization
    func setup(model: ActivityDetailsModel)
    {
        viewModel = ActivityDetailsViewModel(model: model)
    }
    
    // MARK: - Actions
    @IBAction func onBack()
    {
        navigationController?.popViewController(animated: true)
    }
}

private extension ActivityDetailsViewController
{
    func setupUI()
    {
        headerView.backgroundColor = .backgroundGray
        
        titleLabel.text = viewModel?.title
        subtitleLabel.text = viewModel?.subtitle
        descriptionLabel.text = viewModel?.description
        if let reagents = viewModel?.reagents,
           let quantities = viewModel?.quantities
        {
            reagentsLabel?.text = reagents
            quantitiesLabel?.text = quantities
        }
        else
        {
            reagentsStackView?.removeFromSuperview()
        }
        guard let url = viewModel?.imageURL else { return }
        headerImageView.kf.setImage(with: url)
    }
}
