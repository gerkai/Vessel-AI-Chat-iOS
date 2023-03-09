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
    @IBOutlet private weak var scheduleSection: UIView!
    @IBOutlet private weak var removeFromPlanButton: BounceButton!
    @IBOutlet private weak var emptyScheduleLabel: UILabel!
    @IBOutlet private weak var scheduleStackView: UIStackView!
    
    @Resolved internal var analytics: Analytics
    let flowName: AnalyticsFlowName = .todayTabFlow
    
    // MARK: - Model
    private var viewModel: ActivityDetailsViewModel?
    private var showReminders: Bool = RemoteConfigManager.shared.getValue(for: .remindersFeature) as? Bool ?? false
    
    // MARK: - UIViewController Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //get notified when new reminders comes in from the server
        NotificationCenter.default.addObserver(self, selector: #selector(self.dataUpdated(_:)), name: .newDataArrived, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        if scrollView.frame.height - scrollView.contentSize.height > 0
        {
            view.backgroundColor = .codGray
        }
        
        setupUI()
    }
    
    // MARK: - Initialization
    func setup(model: ActivityDetailsModel)
    {
        viewModel = ActivityDetailsViewModel(model: model)
    }
    
    // MARK: - Notifications
    
    @objc
    func dataUpdated(_ notification: NSNotification)
    {
        if let type = notification.userInfo?["objectType"] as? String
        {
            Log_Add("Activity details: dataUpdated: \(type)")
            if type == String(describing: Reminder.self)
            {
                setupUI()
            }
        }
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
    
    @IBAction func onEditSchedule()
    {
        if viewModel?.type == .activity
        {
            let activities = PlansManager.shared.activities
            let activityPlans = PlansManager.shared.getActivityPlans()
            guard let planId = viewModel?.id,
                  let plan = activityPlans.first(where: { $0.id == planId }),
                  let activity = activities.first(where: { $0.id == plan.typeId }) else
            {
                assertionFailure("ActivityDetailsViewController-onEditSchedule: Can't find plan or activity with id: \(viewModel?.id ?? 0)")
                return
            }
            
            analytics.log(event: .addReminder(planId: plan.id, typeId: plan.typeId, planType: .activity))
            
            let reminders = RemindersManager.shared.getRemindersForPlan(planId: plan.id)
            if reminders.count > 0
            {
                let storyboard = UIStoryboard(name: "Reminders", bundle: nil)
                let addReminderVC = storyboard.instantiateViewController(identifier: "RemindersViewController") as! RemindersViewController
                addReminderVC.hidesBottomBarWhenPushed = true
                addReminderVC.viewModel = RemindersViewModel(planId: plan.id, reminders: reminders, activity: activity)
                navigationController?.pushViewController(addReminderVC, animated: true)
            }
            else
            {
                let storyboard = UIStoryboard(name: "Reminders", bundle: nil)
                let addReminderVC = storyboard.instantiateViewController(identifier: "AddReminderViewController") as! AddReminderViewController
                addReminderVC.hidesBottomBarWhenPushed = true
                addReminderVC.viewModel = AddReminderViewModel(planId: plan.id, activity: activity)
                navigationController?.pushViewController(addReminderVC, animated: true)
            }
        }
        else if viewModel?.type == .food
        {
            let foodPlans = PlansManager.shared.getFoodPlans()
            
            guard let planId = viewModel?.id,
                  let plan = foodPlans.first(where: { $0.id == planId }),
                  let food = Contact.main()?.suggestedFoods.first(where: { $0.id == plan.typeId }) else
            {
                assertionFailure("ActivityDetailsViewController-onEditSchedule: Can't find food with id: \(viewModel?.id ?? 0)")
                return
            }
            
            analytics.log(event: .addReminder(planId: plan.id, typeId: plan.typeId, planType: .food))
            
            let reminders = RemindersManager.shared.getRemindersForPlan(planId: plan.id)
            if reminders.count > 0
            {
                let storyboard = UIStoryboard(name: "Reminders", bundle: nil)
                let addReminderVC = storyboard.instantiateViewController(identifier: "RemindersViewController") as! RemindersViewController
                addReminderVC.hidesBottomBarWhenPushed = true
                addReminderVC.viewModel = RemindersViewModel(planId: plan.id, reminders: reminders, food: food)
                navigationController?.pushViewController(addReminderVC, animated: true)
            }
            else
            {
                let storyboard = UIStoryboard(name: "Reminders", bundle: nil)
                let addReminderVC = storyboard.instantiateViewController(identifier: "AddReminderViewController") as! AddReminderViewController
                addReminderVC.hidesBottomBarWhenPushed = true
                addReminderVC.viewModel = AddReminderViewModel(planId: plan.id, food: food)
                navigationController?.pushViewController(addReminderVC, animated: true)
            }
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
        setupScheduleSection()
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
    
    func setupScheduleSection()
    {
        scheduleSection.isHidden = !showReminders
        emptyScheduleLabel.isHidden = !(viewModel?.remindersAreEmpty ?? false)
        scheduleStackView.removeAllArrangedSubviews()
        for schedules in viewModel?.remindersSchedules ?? []
        {
            let scheduleView = ActivityDetailsScheduleView(frame: .zero)
            scheduleView.setup(dayText: schedules.day, timeText: schedules.time)
            scheduleStackView.addArrangedSubview(scheduleView)
        }
    }
}
