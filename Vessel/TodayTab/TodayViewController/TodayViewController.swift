//
//  TodayViewController.swift
//  Vessel
//
//  Created by Nicolas Medina on 9/26/22.
//

import UIKit
import SafariServices

class TodayViewController: UIViewController, VesselScreenIdentifiable, TodayWebViewControllerDelegate
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.newPlanAdded(_:)), name: .newPlanAdded, object: nil)
        
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("❇️ \(self)")
        }
    }
    
    deinit
    {
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("❌ \(self)")
        }
        NotificationCenter.default.removeObserver(self)
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
            ObjectStore.shared.clientSave(contact)
        }
        else if contact.flags & Constants.SAW_ACTIVITY_POPUP == 0
        {
            //show the "Congrats for adding your first activity" popup but only if they haven't seen it
            //yet and only if the first activity was added today (VH-5081)
            let plans = PlansManager.shared.getActivityPlans()
            if plans.count != 0
            {
                let plan = plans.first!
                if let date = Date.from(vesselTime: plan.last_updated)
                {
                    if Calendar.current.isDateInToday(date)
                    {
                        let vc = ActivityPopupViewController.createWith(plan: plans.first!)
                        self.present(vc, animated: false)
                    }
                }
                contact.flags |= Constants.SAW_ACTIVITY_POPUP
                ObjectStore.shared.clientSave(contact)
            }
        }
        else
        {
            //prompt the user to rate their experience (if they haven't done so already)
            ReviewManagerExperienceReview(presentOverVC: self)
        }
    }
    
    func openSupplementQuiz()
    {
        Server.shared.multipassURL(path: Server.shared.FuelQuizURL())
        { url in
            print("SUCCESS: \(url)")
            let vc = TodayWebViewController.initWith(url: url, delegate: self)
            self.present(vc, animated: true)
        }
        onFailure:
        { string in
            print("Failure: \(string)")
        }
    }
    
    func openFormulation()
    {
        Server.shared.multipassURL(path: Server.shared.FuelFormulationURL())
        { url in
            print("SUCCESS: \(url)")
            let vc = TodayWebViewController.initWith(url: url, delegate: self)
            self.present(vc, animated: true)
        }
        onFailure:
        { string in
            print("Failure: \(string)")
        }
    }
    
    // MARK: - Actions
    @IBAction func onTakeATest()
    {
        mainTabBarController?.vesselButtonPressed()
    }
    
    // MARK: - Notifications
    
    @objc
    func dataUpdated(_ notification: NSNotification)
    {
        if let type = notification.userInfo?["objectType"] as? String
        {
            Log_Add("Today Page: dataUpdated: \(type)")
            if type == String(describing: Food.self) || type == String(describing: Plan.self)
            {
                viewModel.refreshLastWeekProgress()
                viewModel.refreshContactSuggestedfoods()
                reloadUI()
            }
            else if type == String(describing: Lesson.self)
            {
                viewModel.refreshLastWeekProgress()
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
    
    @objc
    func newPlanAdded(_ notification: NSNotification)
    {
        viewModel.lastDayProgress = PlansManager.shared.calculateProgressFor(date: Date.serverDateFormatter.string(from: Date()))
        reloadUI()
    }
    
    // MARK: - UI
    
    private func reloadUI()
    {
        print("Today Tab: reloadUI")
        tableView.reloadData()
    }
    
    func showGamificationCongratulationsViewIfNeeded()
    {
        guard viewModel.showProgressDays else { return }
        let todayString = Date.serverDateFormatter.string(from: Date())
        let todayProgress = PlansManager.shared.calculateProgressFor(date: todayString)
        guard viewModel.lastDayProgress != todayProgress else { return }
        viewModel.lastDayProgress = todayProgress
        guard viewModel.isToday && todayProgress == 1.0 else { return }
        
        let congratulationsView = GamificationCongratulationsView()
        congratulationsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: congratulationsView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 462.0)
        ])
        
        let numberOfActivities = PlansManager.shared.getActivityPlans().count
        let numberOfFoods = Contact.main()?.suggestedFoods.count ?? 0
        let totalWaterAmount = Contact.main()?.dailyWaterIntake ?? 0
        let completedInsights = LessonsManager.shared.getLessonsCompletedOn(dateString: todayString).count
        analytics.log(event: .everythingComplete(date: todayString,
                                                 numberOfActivities: numberOfActivities,
                                                 numberOfFoods: numberOfFoods,
                                                 totalWaterAmount: totalWaterAmount,
                                                 completedInsights: completedInsights))
        
        GenericAlertViewController.presentAlert(in: self,
                                                type: .customViewButton(view: congratulationsView, button: GenericAlertButtonInfo(label: GenericAlertLabelInfo(title: NSLocalizedString("Ask Your Health Coach", comment: "")), type: .dark)),
                                                description: GenericAlertViewController.GAMIFICATION_CONGRATULATIONS_ALERT,
                                                showCloseButton: true,
                                                showConfetti: true,
                                                delegate: self)
    }
    
    //MARK: - FUEL
    func todayWebViewDismissed()
    {
        Contact.main()!.getFuelStatus
        {
            PlansManager.shared.loadPlans()
        }
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
        viewModel.sections[safe: indexPath.section]?.cells[safe: indexPath.row]?.height ?? 0.0 + ViewConstants.TABLE_VIEW_SPACING
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
        case .lockedCheckMarkCard(let backgroundImage):
            guard let cell = cell as? TodayLockedCheckMarkCardCell else { fatalError("Can't dequeue cell TodayLockedCheckMarkCardCell from tableView in TodayViewController") }
            cell.setup(backgroundImage: backgroundImage)
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
                coordinator.delegate = self
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
                    guard let viewController = coordinator.getNextStepViewController(shouldSave: viewModel.isToday && lesson.completedDate == nil) else { return }
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
                let plans = PlansManager.shared.getActivityPlans() + PlansManager.shared.getLifestyleRecommendationPlans()
                
                guard let activity = activities[safe: indexPath.row - 1],
                      let plan = plans.first(where: { activity.isLifestyleRecommendation ? $0.typeId == activity.id && $0.type == .lifestyleRecommendation : $0.typeId == activity.id && $0.type == .activity }) else { return }
                if (plan.typeId == Constants.GET_SUPPLEMENTS_LIFESTYLE_RECOMMENDATION_ID) && (activity.isLifestyleRecommendation)
                {
                    openSupplementQuiz()
                }
                else if activity.isLifestyleRecommendation && ((activity.id == -Constants.FUEL_AM_LIFESTYLE_RECOMMENDATION_ID) || (activity.id == -Constants.FUEL_PM_LIFESTYLE_RECOMMENDATION_ID))
                {
                    openFormulation()
                }
                else if !activity.isLifestyleRecommendation
                {
                    let storyboard = UIStoryboard(name: "TodayTab", bundle: nil)
                    let activityDetailsVC = storyboard.instantiateViewController(identifier: "ActivityDetailsViewController") as! ActivityDetailsViewController
                    activityDetailsVC.hidesBottomBarWhenPushed = true
                    activityDetailsVC.setup(model: activity.getActivityDetailsModel(planId: plan.id))
                    analytics.log(event: .activityShown(activityId: activity.id, activityName: activity.title))
                    
                    navigationController?.pushViewController(activityDetailsVC, animated: true)
                }
            }
        case .food:
            guard (Contact.main()?.suggestedFoods ?? []).count > 0 else
            {
                mainTabBarController?.vesselButtonPressed()
                return
            }
            
            if indexPath.row == 0
            {
                GenericAlertViewController.presentAlert(in: self, type:
                                                            GenericAlertType.titleSubtitleButton(title: GenericAlertLabelInfo(title: NSLocalizedString("Food is wellness", comment: ""), font: Constants.FontTitleMain24),
                                                                                                 subtitle: GenericAlertLabelInfo(title: NSLocalizedString("Try to eat at least one of your food recommendations daily to keep your body and mind feeling great.", comment: ""), font: Constants.FontBodyAlt16, alignment: .center, height: 80.0),
                                                                                                 button: GenericAlertButtonInfo(label: GenericAlertLabelInfo(title: NSLocalizedString("Got it!", comment: "")), type: .dark)))
            }
        case .water:
            guard Contact.main()?.dailyWaterIntake != nil else
            {
                mainTabBarController?.vesselButtonPressed()
                return
            }
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
        showGamificationCongratulationsViewIfNeeded()
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
            PlansManager.shared.setPlanCompleted(planId: plan.id, date: togglePlanData.date, isComplete: togglePlanData.completed)
            guard let cell = self.tableView.cellForRow(at: IndexPath(row: 1, section: TodayViewSection.food(foods: [], selectedDate: "").sectionIndex)) as? TodayFoodDetailsSectionTableViewCell else { return }
            cell.updateCheckedFoods()
            self.showGamificationCongratulationsViewIfNeeded()
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
        if type == .activity || type == .lifestyleRecommendation
        {
            return false
        }
        return true
    }
    
    func onCardChecked(id: Int, type: CheckMarkCardType)
    {
        if type == .lifestyleRecommendation
        {
            let lifestyleRecommendationPlans = PlansManager.shared.getLifestyleRecommendationPlans()
            guard let plan = lifestyleRecommendationPlans.first(where: { $0.typeId == id }) else { return }

            if plan.typeId == Constants.GET_SUPPLEMENTS_LIFESTYLE_RECOMMENDATION_ID
            {
                openSupplementQuiz()
            }
            else
            {
                PlansManager.shared.setPlanCompleted(planId: plan.id, date: viewModel.selectedDate, isComplete: true)
                self.tableView.reloadData()
                self.showGamificationCongratulationsViewIfNeeded()
            }
        }
        else if type == .activity
        {
            let activities = PlansManager.shared.activities
            let activityPlans = PlansManager.shared.getActivityPlans()
            guard let plan = activityPlans.first(where: { $0.typeId == id }) else { return }
            
            if let activity = activities.first(where: { $0.id == plan.typeId })
            {
                analytics.log(event: .activityComplete(activityId: activity.id, activityName: activity.title, completed: !plan.completed.contains(viewModel.selectedDate)))
            }
            
            Server.shared.completePlan(planId: plan.id, toggleData: TogglePlanData(date: viewModel.selectedDate, completed: !plan.completed.contains(viewModel.selectedDate)))
            { [weak self] togglePlanData in
                guard let self = self else { return }
                PlansManager.shared.setPlanCompleted(planId: plan.id, date: togglePlanData.date, isComplete: togglePlanData.completed)
                self.tableView.reloadData()
                self.showGamificationCongratulationsViewIfNeeded()
            } onFailure: { error in
                self.tableView.reloadData()
            }
        }
        else if type == .lesson
        {
            let lessons = LessonsManager.shared.todayLessons
            guard let lesson = lessons.first(where: { $0.id == id }) else { return }
            let coordinator = LessonsCoordinator(lesson: lesson)
            coordinator.delegate = self
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
                guard let viewController = coordinator.getNextStepViewController(shouldSave: viewModel.isToday && lesson.completedDate == nil) else { return }
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

extension TodayViewController: LessonsCoordinatorDelegate
{
    func onLessonFinished()
    {
        self.showGamificationCongratulationsViewIfNeeded()
    }
}

extension TodayViewController: GenericAlertDelegate
{
    func onAlertButtonTapped(_ alert: GenericAlertViewController, index: Int, alertDescription: String)
    {
        if alertDescription == GenericAlertViewController.GAMIFICATION_CONGRATULATIONS_ALERT
        {
            tabBarController?.selectedIndex = Constants.TAB_BAR_COACH_INDEX
        }
    }
}
