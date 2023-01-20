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
    @IBOutlet private weak var removeFromPlanButton: BounceButton!
    @IBOutlet private weak var removePlanLayoutConstraint: NSLayoutConstraint!
    
    @Resolved internal var analytics: Analytics
    let flowName: AnalyticsFlowName = .todayTabFlow
    private var shouldShowRemovePlan: Bool = true
    
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
    func setup(model: ActivityDetailsModel, shouldShowRemovePlan: Bool = true)
    {
        viewModel = ActivityDetailsViewModel(model: model)
        self.shouldShowRemovePlan = shouldShowRemovePlan
    }
    
    // MARK: - Actions
    @IBAction func onBack()
    {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onRemovePlan()
    {
        guard let viewModel = viewModel else { return }
        removeFromPlanButton.isEnabled = false
        Server.shared.removeSinglePlan(planId: viewModel.id)
        {
            self.removeFromPlanButton.isEnabled = true
            self.navigationController?.popViewController(animated: true)
            guard let plan = PlansManager.shared.plans.first(where: { $0.id == viewModel.id }) else { return }
            PlansManager.shared.removePlans(plansToRemove: [plan])
        }
        onFailure:
        { error in
            self.removeFromPlanButton.isEnabled = true
        }
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
        removePlanLayoutConstraint.constant = shouldShowRemovePlan ? 128 : 0
        removeFromPlanButton.isHidden = !shouldShowRemovePlan
        scrollView.layoutIfNeeded()
        
        guard let url = viewModel?.imageURL else { return }
        headerImageView.kf.setImage(with: url)
    }
}
