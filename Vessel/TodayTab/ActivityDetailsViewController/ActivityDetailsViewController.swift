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
    @IBOutlet private weak var reagentsLabel: UILabel!
    
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
    func setup(food: Food)
    {
        viewModel = ActivityDetailsViewModel(food: food)
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
        headerView.backgroundColor = .backgroundRed
        
        titleLabel.text = viewModel?.title
        subtitleLabel.text = viewModel?.subtitle
        descriptionLabel.text = viewModel?.description
        reagentsLabel.text = viewModel?.reagents
        guard let url = viewModel?.foodImageURL else { return }
        headerImageView.kf.setImage(with: url)
    }
}

extension ActivityDetailsViewController: UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if scrollView.contentOffset.y <= 0
        {
            view.backgroundColor = .backgroundRed
        }
        else
        {
            view.backgroundColor = .codGray
        }
    }
}
