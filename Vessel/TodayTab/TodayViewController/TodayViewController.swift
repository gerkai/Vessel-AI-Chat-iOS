//
//  TodayViewController.swift
//  Vessel
//
//  Created by Nicolas Medina on 9/26/22.
//

import UIKit

class TodayViewController: UIViewController, VesselScreenIdentifiable
{
    // MARK: - Constants
    private struct ViewConstants
    {
        static let TABLE_VIEW_SPACING = 16.0
    }
    
    // MARK: - UI
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Model
    private var viewModel = TodayViewModel()
    private let resultsViewModel = ResultsTabViewModel()
    private var tableViewOffset: CGFloat?
    
    @Resolved internal var analytics: Analytics
    let flowName: AnalyticsFlowName = .todayTabFlow
    
    // MARK: - UIViewController Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        resultsViewModel.refresh()
        
        //get notified when new foods, plans or results comes in from After Test Flow
        NotificationCenter.default.addObserver(self, selector: #selector(self.dataUpdated(_:)), name: .newDataArrived, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        reloadUI()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        guard let contact = Contact.main() else { return }
        
        if contact.flags & Constants.SAW_INSIGHT_POPUP == 0
        {
            let vc = InsightsPopupViewController.create()
            self.present(vc, animated: false)
            
            contact.flags |= Constants.SAW_INSIGHT_POPUP
            ObjectStore.shared.ClientSave(contact)
        }
        else if contact.flags & Constants.SAW_ACTIVITY_POPUP == 0
        {
            let plans = PlansManager.shared.getActivities()
            if plans.count != 0
            {
                let vc = ActivityPopupViewController.createWith(plan: plans.first!)
                self.present(vc, animated: false)
                
                contact.flags |= Constants.SAW_ACTIVITY_POPUP
                ObjectStore.shared.ClientSave(contact)
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func onTakeATest()
    {
        mainTabBarController?.vesselButtonPressed()
    }
    
    // MARK: - Notifications
    
    @objc func dataUpdated(_ notification: NSNotification)
    {
        if let type = notification.userInfo?["objectType"] as? String
        {
            Log_Add("Today Page: dataUpdated: \(type)")
            if type == String(describing: Food.self) || type == String(describing: Plan.self)
            {
                viewModel.refreshContactSuggestedfoods()
                reloadUI()
            }
            else if type == String(describing: Lesson.self)
            {
                reloadUI()
            }
            else if type == String(describing: Curriculum.self)
            {
                if !LessonsManager.shared.planBuilt
                {
                    LessonsManager.shared.buildLessonPlan(onDone: {})
                }
            }
        }
    }
    
    private func reloadUI()
    {
        print("Today Tab: reloadUI")
        tableView.reloadData()
    }
}

extension TodayViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        viewModel.sections[section].cells.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        viewModel.sections[indexPath.section].cells[indexPath.row].height + (viewModel.sections[indexPath.section] == viewModel.sections.last ? max(0.0, tableViewOffset ?? 0.0) : ViewConstants.TABLE_VIEW_SPACING)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let section = viewModel.sections[safe: indexPath.section],
              let cellData = section.cells[safe: indexPath.row] else
        {
            fatalError("Can't get cell data from viewModel in TodayViewController")
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellData.identifier, for: indexPath)
        switch cellData
        {
        case .header(let name, let goals):
            guard let cell = cell as? TodayHeaderTableViewCell else { fatalError("Can't dequeue cell TodayHeaderTableViewCell from tableView in TodayViewController") }
            cell.setup(name: name, goals: goals, delegate: self)
        case .progressDays(let progress):
            guard let cell = cell as? TodayProgressDaysCell else { fatalError("Can't dequeue cell TodayProgressDaysCell from tableView in TodayViewController") }
            cell.setup(progress: progress, selectedDay: viewModel.selectedDate, delegate: self)
        case .sectionTitle(let icon, let name):
            guard let cell = cell as? TodaySectionTitleTableViewCell else { fatalError("Can't dequeue cell TodaySectionTitleTableViewCell from tableView in TodayViewController") }
            cell.setup(iconName: icon, title: name)
        case .foodDetails(let foods, let selectedDate):
            guard let cell = cell as? TodayFoodDetailsSectionTableViewCell else { fatalError("Can't dequeue cell TodayFoodDetailsSectionTableViewCell from tableView in TodayViewController") }
            cell.setup(foods: foods, selectedDate: selectedDate, delegate: self)
        case .waterDetails(let glassesNumber, let checkedGlasses):
            guard let cell = cell as? TodayWaterDetailsSectionTableViewCell else { fatalError("Can't dequeue cell TodayWaterDetailsSectionTableViewCell from tableView in TodayViewController") }
            cell.setup(glassesNumber: glassesNumber, checkedGlasses: checkedGlasses, delegate: self)
        case .checkMarkCard(let title, let subtitle, let description, let backgroundImage, let isCompleted, let id, let type):
            guard let cell = cell as? TodayCheckMarkCardTableViewCell else { fatalError("Can't dequeue cell TodayCheckMarkCardTableViewCell from tableView in TodayViewController") }
            cell.setup(title: title, subtitle: subtitle, description: description, backgroundImage: backgroundImage, completed: isCompleted, id: id, type: type, delegate: self)
        case .foldedCheckMarkCard(let title, let subtitle, let backgroundImage):
            guard let cell = cell as? TodayCheckMarkCardTableViewCell else { fatalError("Can't dequeue cell TodayCheckMarkCardTableViewCell from tableView in TodayViewController") }
            cell.setup(title: title, subtitle: subtitle, description: nil, backgroundImage: backgroundImage, completed: true)
        case .text(let text):
            guard let cell = cell as? TodayTextCell else  { fatalError("Can't dequeue cell TodayTextCell from tableView in TodayViewController") }
            cell.setup(text: text)
        case .button(let text):
            guard let cell = cell as? TodayButtonCell else  { fatalError("Can't dequeue cell TodayTextCell from tableView in TodayViewController") }
            cell.setup(title: text, delegate: self)
            break
        case .footer:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        guard viewModel.isToday else { return indexPath }
        guard let section = viewModel.sections[safe: indexPath.section] else { return nil }
        switch section
        {
        case .insights(let lessons, _):
            if indexPath.row == 2 || (indexPath.row == (lessons.count + 2))
            {
                return nil
            }
        default:
            break
        }
        
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        guard let section = viewModel.sections[safe: indexPath.section] else { return }
        switch section
        {
        case .insights(let lessons, _):
            if indexPath.row == 0
            {
                GenericAlertViewController.presentAlert(in: self, type:
                                                            GenericAlertType.titleSubtitleButton(title: GenericAlertLabelInfo(title: NSLocalizedString("An insight a day keeps the doctor away.", comment: ""), font: Constants.FontTitleMain24),
                                                                                                 subtitle: GenericAlertLabelInfo(title: NSLocalizedString("Each day you'll get one new insight to empower you with knowledge to reach your goals.", comment: ""), font: Constants.FontBodyAlt16, alignment: .center, height: 80.0),
                                                                                                 button: GenericAlertButtonInfo(label: GenericAlertLabelInfo(title: NSLocalizedString("Got it!", comment: "")), type: .dark)))
            }
            else
            {
                // Substract title row and today insights done text row
                let row = lessons.count > 1 && indexPath.row > 1 && viewModel.isToday ? indexPath.row - 2 : indexPath.row - 1
                let lesson = lessons[row]
                let coordinator = LessonsCoordinator(lesson: lesson)
                if let index = lesson.indexOfFirstUnreadStep()
                {
                    for _ in stride(from: 0, to: index, by: 1)
                    {
                        guard let viewController = coordinator.getNextStepViewController(shouldSave: false) else { return }
                        navigationController?.pushViewController(viewController, animated: false)
                    }
                    guard let viewController = coordinator.getNextStepViewController(shouldSave: false) else { return }
                    navigationController?.fadeTo(viewController)
                }
                else
                {
                    guard let viewController = coordinator.getNextStepViewController(shouldSave: viewModel.isToday) else { return }
                    navigationController?.pushViewController(viewController, animated: true)
                }
            }
        case .activities(let activities, _):
            if indexPath.row == 0
            {
                GenericAlertViewController.presentAlert(in: self, type:
                                                            GenericAlertType.titleSubtitleButton(title: GenericAlertLabelInfo(title: NSLocalizedString("Build healthy habits", comment: ""), font: Constants.FontTitleMain24),
                                                                                                 subtitle: GenericAlertLabelInfo(title: NSLocalizedString("These are the actions you can take to build the habits needed to reach your goals.", comment: ""), font: Constants.FontBodyAlt16, alignment: .center, height: 80.0),
                                                                                                 button: GenericAlertButtonInfo(label: GenericAlertLabelInfo(title: NSLocalizedString("Got it!", comment: "")), type: .dark)))
            }
            else
            {
                guard let activity = activities[safe: indexPath.row - 1],
                      let plan = PlansManager.shared.getActivities().first(where: { $0.typeId == activity.id }) else { return }
                let storyboard = UIStoryboard(name: "TodayTab", bundle: nil)
                let activityDetailsVC = storyboard.instantiateViewController(identifier: "ActivityDetailsViewController") as! ActivityDetailsViewController
                activityDetailsVC.hidesBottomBarWhenPushed = true
                activityDetailsVC.setup(model: activity.getActivityDetailsModel(planId: plan.id))
                analytics.log(event: .activityShown(activityId: activity.id, activityName: activity.title))
                
                navigationController?.pushViewController(activityDetailsVC, animated: true)
            }
        case .food:
            if indexPath.row == 0
            {
                GenericAlertViewController.presentAlert(in: self, type:
                                                            GenericAlertType.titleSubtitleButton(title: GenericAlertLabelInfo(title: NSLocalizedString("Food is wellness", comment: ""), font: Constants.FontTitleMain24),
                                                                                                 subtitle: GenericAlertLabelInfo(title: NSLocalizedString("Try to eat at least one of your food recommendations daily to keep your body and mind feeling great.", comment: ""), font: Constants.FontBodyAlt16, alignment: .center, height: 80.0),
                                                                                                 button: GenericAlertButtonInfo(label: GenericAlertLabelInfo(title: NSLocalizedString("Got it!", comment: "")), type: .dark)))
            }
        case .water:
            let storyboard = UIStoryboard(name: "TodayTab", bundle: nil)
            let waterDetailsVC = storyboard.instantiateViewController(identifier: "WaterDetailsViewController") as! WaterDetailsViewController
            waterDetailsVC.hidesBottomBarWhenPushed = true
            waterDetailsVC.drinkedWaterGlasses = viewModel.drinkedWaterGlasses
            waterDetailsVC.numberOfGlasses = viewModel.numberOfGlasses ?? Constants.MINIMUM_WATER_INTAKE
            waterDetailsVC.waterIntakeViewDelegate = self
            navigationController?.pushViewController(waterDetailsVC, animated: true)
        default:
            break
        }
    }
}

extension TodayViewController: WaterIntakeViewDelegate
{
    func didCheckGlasses(_ glasses: Int)
    {
        viewModel.updateCheckedGlasses(glasses)
    }
}

extension TodayViewController: FoodCheckmarkViewDelegate
{
    func checkmarkTapped(view: FoodCheckmarkView)
    {
        let foodPlans = PlansManager.shared.getFoodPlans()
        guard let plan = foodPlans.first(where: { $0.typeId == view.food?.id }) else { return }
        
        if let food = view.food
        {
            analytics.log(event: .foodComplete(foodId: food.id, foodName: food.title, completed: view.isChecked))
        }
        
        Server.shared.completePlan(planId: plan.id, toggleData: TogglePlanData(date: viewModel.selectedDate, completed: view.isChecked))
        { [weak self] togglePlanData in
            guard let self = self else { return }
            PlansManager.shared.togglePlanCompleted(planId: plan.id, date: togglePlanData.date, completed: togglePlanData.completed)
            guard let cell = self.tableView.cellForRow(at: IndexPath(row: 1, section: TodayViewSection.food(foods: [], selectedDate: "").sectionIndex)) as? TodayFoodDetailsSectionTableViewCell else { return }
            cell.updateCheckedFoods()
        } onFailure: { error in
            guard let cell = self.tableView.cellForRow(at: IndexPath(row: 1, section: TodayViewSection.food(foods: [], selectedDate: "").sectionIndex)) as? TodayFoodDetailsSectionTableViewCell else { return }
            cell.updateCheckedFoods()
        }
    }
    
    func checkmarkViewTapped(view: FoodCheckmarkView)
    {
        guard let food = view.food,
        let plan = PlansManager.shared.getFoodPlans().first(where: { $0.typeId == food.id }) else { return }
        let storyboard = UIStoryboard(name: "TodayTab", bundle: nil)
        let activityDetailsVC = storyboard.instantiateViewController(identifier: "ActivityDetailsViewController") as! ActivityDetailsViewController
        activityDetailsVC.hidesBottomBarWhenPushed = true
        activityDetailsVC.setup(model: food.getActivityDetailsModel(planId: plan.id))
        
        analytics.log(event: .foodShown(foodId: food.id, foodName: food.title))
        
        navigationController?.pushViewController(activityDetailsVC, animated: true)
    }
}

extension TodayViewController: TodayHeaderTableViewCellDelegate
{
    func onGoalTapped(goal: String)
    {
        resultsViewModel.refresh()
        guard let goalIndex = Goals.firstIndex(where: { $1.name == goal.lowercased() }) else { return }
        let id = Goals[goalIndex].key.rawValue
        
        let goalID = Goal.ID(rawValue: id)!
        let vc = GoalDetailsViewController.initWith(goal: goalID, viewModel: resultsViewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension TodayViewController: TodayButtonCellDelegate
{
    func onButtonPressed()
    {
        LessonsManager.shared.unlockMoreInsights = true
        reloadUI()
    }
}

extension TodayViewController: TodayCheckMarkCardDelegate
{
    func canUncheckCard(type: CheckMarkCardType) -> Bool
    {
        if type == .activity
        {
            return false
        }
        return true
    }
    
    func onCardChecked(id: Int, type: CheckMarkCardType)
    {
        if type == .activity
        {
            let activities = PlansManager.shared.activities
            let activityPlans = PlansManager.shared.getActivities()
            guard let plan = activityPlans.first(where: { $0.typeId == id }) else { return }
            
            if let activity = activities.first(where: { $0.id == plan.typeId })
            {
                analytics.log(event: .activityComplete(activityId: activity.id, activityName: activity.title, completed: !plan.completed.contains(viewModel.selectedDate)))
            }
            
            Server.shared.completePlan(planId: plan.id, toggleData: TogglePlanData(date: viewModel.selectedDate, completed: !plan.completed.contains(viewModel.selectedDate)))
            { [weak self] togglePlanData in
                guard let self = self else { return }
                PlansManager.shared.togglePlanCompleted(planId: plan.id, date: togglePlanData.date, completed: togglePlanData.completed)
                self.tableView.reloadData()
            } onFailure: { error in
                self.tableView.reloadData()
            }
        }
        else if type == .lesson
        {
            let lessons = LessonsManager.shared.todayLessons
            guard let lesson = lessons.first(where: { $0.id == id }) else { return }
            let coordinator = LessonsCoordinator(lesson: lesson)
            if let index = lesson.indexOfFirstUnreadStep()
            {
                for _ in stride(from: 0, to: index, by: 1)
                {
                    guard let viewController = coordinator.getNextStepViewController() else { return }
                    navigationController?.pushViewController(viewController, animated: false)
                }
                guard let viewController = coordinator.getNextStepViewController() else { return }
                navigationController?.fadeTo(viewController)
            }
            else
            {
                guard let viewController = coordinator.getNextStepViewController() else { return }
                navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
}

extension TodayViewController: ProgressDayViewDelegate
{
    func onProgressDayTapped(date: String)
    {
        viewModel.selectedDate = date
        tableView.reloadData()
    }
}
