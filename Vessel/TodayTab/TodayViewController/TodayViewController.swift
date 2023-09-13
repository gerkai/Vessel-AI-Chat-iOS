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
        viewModel.resultsViewModel = resultsViewModel
        viewModel.showReminders = true
        
        //get notified when new food, plans or results comes in from After Test Flow
        NotificationCenter.default.addObserver(self, selector: #selector(self.dataUpdated(_:)), name: .newDataArrived, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.newPlanAdded(_:)), name: .newPlanAddedOrRemoved, object: nil)
        
        HealthKitManager.shared.authorizeHealthKit(completion: { success, error in
            print("success: \(success)")
            print("error: \(String(describing: error))")
        })
        
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
        RemindersManager.shared.setupActivityReminders(activities: PlansManager.shared.activities)
        reloadUI()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        guard let contact = Contact.main() else
        {
            assertionFailure("TodayViewController-viewDidAppear: mainContact not available")
            return
        }
        var canShowReview = true
        
        if contact.flags & Constants.SAW_INSIGHT_POPUP == 0
        {
            let vc = InsightsPopupViewController.create()
            self.present(vc, animated: false)
            
            contact.flags |= Constants.SAW_INSIGHT_POPUP
            ObjectStore.shared.clientSave(contact)
            canShowReview = false
        }
        else if contact.flags & Constants.SAW_ACTIVITY_POPUP == 0
        {
            //show the "Congrats for adding your first activity" popup but only if they haven't seen it
            //yet and only if the first activity was added today (VH-5081)
            let plans = PlansManager.shared.getActivityPlans(shouldFilterForToday: true)
            if plans.count != 0
            {
                let plan = plans.first!
                if let date = Date.from(vesselTime: plan.last_updated)
                {
                    if Calendar.current.isDateInToday(date)
                    {
                        let vc = ActivityPopupViewController.createWith(plan: plans.first!)
                        self.present(vc, animated: false)
                        canShowReview = false
                    }
                }
                contact.flags |= Constants.SAW_ACTIVITY_POPUP
                ObjectStore.shared.clientSave(contact)
            }
        }
        if canShowReview
        {
            //prompt the user to rate their experience (if they haven't done so already)
            ReviewManagerExperienceReview(presentOverVC: self)
        }
        if let route = RouteManager.shared.pendingRoutingOption
        {
            Log_Add("Routing pending option to: \(route.rawValue)")
            RouteManager.shared.pendingRoutingOption = nil
            _ = RouteManager.shared.routeTo(route)
        }
    }
    
    func openSupplementQuiz()
    {
        analytics.log(event: .prlTodayPageGetSupplement(expertID: Contact.main()!.pa_id))
        if let expertID = Contact.main()!.expert_id
        {
            ObjectStore.shared.get(type: Expert.self, id: expertID)
            { [weak self] expert in
                guard let self = self else { return }
                if let urlCode = expert.url_code
                {
                    let expertFuelQuizURL = Server.shared.ExpertFuelQuizURL(urlCode: urlCode)
                    self.showSupplementQuiz(path: expertFuelQuizURL)
                }
            }
            onFailure:
            { [weak self] in
                guard let self = self else { return }
                self.showSupplementQuiz(path: Server.shared.FuelQuizURL())
            }
        }
        else
        {
            showSupplementQuiz(path: Server.shared.FuelQuizURL())
        }
    }
    
    private func showSupplementQuiz(path: String)
    {
        Server.shared.multipassURL(path: path)
        { url in
            Log_Add("Supplement Quiz: \(url)")
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
        analytics.log(event: .prlTodayPageShowIngredients(expertID: Contact.main()!.pa_id))
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
                viewModel.refreshContactSuggestedFood()
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
            else if type == String(describing: Reminder.self)
            {
                reloadUI()
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
        
        let numberOfActivities = PlansManager.shared.getActivityPlans(shouldFilterForToday: viewModel.selectedDate == todayString, shouldFilterForSelectedDate: todayString).count
        let numberOfFood = Contact.main()?.suggestedFood.count ?? 0
        let totalWaterAmount = WaterManager.shared.getDailyWaterIntake(date: viewModel.selectedDate) ?? 0
        let completedInsights = LessonsManager.shared.getLessonsCompletedOn(dateString: todayString).count
        analytics.log(event: .everythingComplete(date: todayString,
                                                 numberOfActivities: numberOfActivities,
                                                 numberOfFood: numberOfFood,
                                                 totalWaterAmount: totalWaterAmount,
                                                 completedInsights: completedInsights))
        
        GenericAlertViewController.presentAlert(in: self,
                                                type: .customViewButton(view: congratulationsView, button: GenericAlertButtonInfo(label: GenericAlertLabelInfo(title: NSLocalizedString("Ask Your Health Coach", comment: "")), type: .dark)),
                                                description: GenericAlertViewController.GAMIFICATION_CONGRATULATIONS_ALERT,
                                                showCloseButton: true,
                                                showConfetti: true,
                                                delegate: self)
    }
    
    func presentSupplementsTutorial()
    {
        let plans = PlansManager.shared.getLifestyleRecommendationPlans()
        guard let plan = plans.first(where: { $0.id == Constants.GET_SUPPLEMENTS_LIFESTYLE_RECOMMENDATION_ID }) else { return }
        tableView.scrollToRow(at: IndexPath(row: 0, section: TodayViewSection.activities(activities: [], selectedDate: "", isToday: viewModel.isToday).sectionIndex), at: .top, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            let vc = LifestyleRecommendationPopupViewController.createWith(plan: plan)
            self.present(vc, animated: false)
        })
    }
    
    //MARK: - FUEL
    func todayWebViewDismissed()
    {
        Contact.main()!.getFuel
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
            assertionFailure("Can't get cell data from viewModel in TodayViewController")
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellData.identifier, for: indexPath)
        switch cellData
        {
        case .header(let name, let goals):
            guard let cell = cell as? TodayHeaderTableViewCell else
            {
                assertionFailure("Can't dequeue cell TodayHeaderTableViewCell from tableView in TodayViewController")
                return UITableViewCell()
            }
            cell.setup(name: name, goals: goals, delegate: self)
        case .progressDays(let progress):
            guard let cell = cell as? TodayProgressDaysCell else
            {
                assertionFailure("Can't dequeue cell TodayProgressDaysCell from tableView in TodayViewController")
                return UITableViewCell()
            }
            cell.setup(progress: progress, selectedDay: viewModel.selectedDate, delegate: self)
        case .sectionTitle(let icon, let name, let showInfoIcon):
            guard let cell = cell as? TodaySectionTitleTableViewCell else
            {
                assertionFailure("Can't dequeue cell TodaySectionTitleTableViewCell from tableView in TodayViewController")
                return UITableViewCell()
            }
            cell.setup(iconName: icon, title: name, showInfoIcon: showInfoIcon)
        case .foodDetails(let food, let selectedDate):
            guard let cell = cell as? TodayFoodDetailsSectionTableViewCell else
            {
                assertionFailure("Can't dequeue cell TodayFoodDetailsSectionTableViewCell from tableView in TodayViewController")
                return UITableViewCell()
            }
            cell.setup(food: food, selectedDate: selectedDate, isToday: viewModel.isToday, delegate: self)
        case .waterDetails(let glassesNumber, let checkedGlasses):
            guard let cell = cell as? TodayWaterDetailsSectionTableViewCell else
            {
                assertionFailure("Can't dequeue cell TodayWaterDetailsSectionTableViewCell from tableView in TodayViewController")
                return UITableViewCell()
            }
            cell.setup(glassesNumber: glassesNumber, checkedGlasses: checkedGlasses, delegate: self)
        case .lockedCheckMarkCard(let backgroundImage, let title, let subtext):
            guard let cell = cell as? TodayLockedCheckMarkCardCell else
            {
                assertionFailure("Can't dequeue cell TodayLockedCheckMarkCardCell from tableView in TodayViewController")
                return UITableViewCell()
            }
            cell.setup(backgroundImage: backgroundImage, title: title, subtext: subtext)
        case .checkMarkCard(let title, let subtitle, let description, let backgroundImage, let isCompleted, let id, let type, let remindersButtonState, let remindersButtonText, let longDescription):
            guard let cell = cell as? TodayCheckMarkCardTableViewCell else
            {
                assertionFailure("Can't dequeue cell TodayCheckMarkCardTableViewCell from tableView in TodayViewController")
                return UITableViewCell()
            }
//            let shouldShowReminderButton = viewModel.showReminders && (type != .lifestyleRecommendation || id != Constants.GET_SUPPLEMENTS_LIFESTYLE_RECOMMENDATION_ID)
//            let remindersButtonState = shouldShowReminderButton ? remindersButtonState : nil
            cell.setup(title: title, subtitle: subtitle, description: description, backgroundImage: backgroundImage, completed: isCompleted, remindersButtonState: type == .activity, remindersButtonTitle: remindersButtonText, id: id, type: type, delegate: self)
        case .foldedCheckMarkCard(let title, let subtitle, let backgroundImage):
            guard let cell = cell as? TodayCheckMarkCardTableViewCell else
            {
                assertionFailure("Can't dequeue cell TodayCheckMarkCardTableViewCell from tableView in TodayViewController")
                return UITableViewCell()
            }
            cell.setup(title: title, subtitle: subtitle, description: nil, backgroundImage: backgroundImage, completed: true)
        case .text(let text, let alignment):
            guard let cell = cell as? TodayTextCell else
            {
                assertionFailure("Can't dequeue cell TodayTextCell from tableView in TodayViewController")
                return UITableViewCell()
            }
            cell.setup(text: text, alignment: alignment)
        case .loader:
            break
        case .button(let text):
            guard let cell = cell as? TodayButtonCell else
            {
                assertionFailure("Can't dequeue cell TodayTextCell from tableView in TodayViewController")
                return UITableViewCell()
            }
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
        print("section: \(section)")
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
        case .activities(let activities, _, _):
            if indexPath.row == 0
            {
                GenericAlertViewController.presentAlert(in: self, type:
                                                            GenericAlertType.titleSubtitleButton(title: GenericAlertLabelInfo(title: NSLocalizedString("Build healthy habits", comment: ""), font: Constants.FontTitleMain24),
                                                                                                 subtitle: GenericAlertLabelInfo(title: NSLocalizedString("These are the actions you can take to build the habits needed to reach your goals.", comment: ""), font: Constants.FontBodyAlt16, alignment: .center, height: 80.0),
                                                                                                 button: GenericAlertButtonInfo(label: GenericAlertLabelInfo(title: NSLocalizedString("Got it!", comment: "")), type: .dark)))
            }
            else if indexPath.row <= activities.count && activities[indexPath.row - 1].isPlan
            {
                let storyboard = UIStoryboard(name: "TodayTab", bundle: nil)
                let activityDetailsVC = storyboard.instantiateViewController(identifier: "NewActivityDetailsViewController") as! NewActivityDetailsViewController
                let activity = activities[indexPath.row - 1]
                activityDetailsVC.imageUrl = activity.imageUrl
                activityDetailsVC.text = activity.longDescription
                navigationController?.pushViewController(activityDetailsVC, animated: true)
            }
            // Handle Apple Health cell case
            else if indexPath.row == 5
            {
                return
            }
            else
            {
                let activityPlans: [Plan] = PlansManager.shared.getActivityPlans(shouldFilterForToday: viewModel.isToday, shouldFilterForSelectedDate: viewModel.selectedDate)
               
                let plans: [Plan] = activityPlans + PlansManager.shared.getLifestyleRecommendationPlans()
                
                guard let activity = activities.filter({ activity in
                    plans.contains(where: { plan in
                        if activity.isLifestyleRecommendation
                        {
                            return plan.typeId == activity.id && plan.type == .reagentLifestyleRecommendation
                        }
                        else
                        {
                            return plan.typeId == activity.id && plan.type == .activity
                        }
                    })
                })[safe: indexPath.row - 1 ],
                      let plan = plans.first(where: { activity.isLifestyleRecommendation ? $0.typeId == activity.id && $0.type == .reagentLifestyleRecommendation : $0.typeId == activity.id && $0.type == .activity }) else
                {
                    assertionFailure("TodayViewController-tableViewDidSelectRowAt.activities: Couldn't find the tapped activity")
                    return
                }
                if (plan.typeId == Constants.GET_SUPPLEMENTS_LIFESTYLE_RECOMMENDATION_ID) && (activity.isLifestyleRecommendation)
                {
                    openSupplementQuiz()
                }
                else if activity.isLifestyleRecommendation && ((activity.id == -Constants.FUEL_AM_LIFESTYLE_RECOMMENDATION_ID) || (activity.id == -Constants.FUEL_PM_LIFESTYLE_RECOMMENDATION_ID))
                {
                    openFormulation()
                }
                else if activity.isLifestyleRecommendation && (activity.id == -Constants.TAKE_A_TEST_LIFESTYLE_RECOMMENDATION_ID)
                {
                    mainTabBarController?.vesselButtonPressed()
                }
                else if !activity.isLifestyleRecommendation
                {
                    let storyboard = UIStoryboard(name: "TodayTab", bundle: nil)
                    let activityDetailsVC = storyboard.instantiateViewController(identifier: "ActivityDetailsViewController") as! ActivityDetailsViewController
                    activityDetailsVC.hidesBottomBarWhenPushed = true
                    let planToRemove = PlansManager.shared.getFirstActivityPlan(withId: activity.id, shouldFilterForToday: viewModel.isToday, shouldFilterForSelectedDay: viewModel.selectedDate)
                    
                    activityDetailsVC.setup(model: activity.getActivityDetailsModel(planId: plan.id), shouldShowRemovePlan: planToRemove != nil)

                    analytics.log(event: .activityShown(activityId: activity.id, activityName: activity.title))
                    
                    navigationController?.pushViewController(activityDetailsVC, animated: true)
                }
            }
        case .food:
            guard (Contact.main()?.suggestedFood ?? []).count > 0 else
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
            guard WaterManager.shared.getDailyWaterIntake(date: viewModel.selectedDate) != nil else
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
        reloadUI()
    }
}

extension TodayViewController: FoodCheckmarkViewDelegate
{
    func checkmarkTapped(view: FoodCheckmarkView)
    {
        let foodPlans: [Plan] = PlansManager.shared.getFoodPlans(shouldFilterForToday: viewModel.isToday, shouldFilterForSelectedDay: viewModel.selectedDate)

        guard let plan = foodPlans.first(where: { $0.typeId == view.food?.id }) else
        {
            assertionFailure("TodayViewController-checkmarkTapped: Couldn't find the tapped food")
            return
        }
        
        if let food = view.food
        {
            analytics.log(event: .foodComplete(foodId: food.id, foodName: food.title, completed: view.isChecked))
        }
        
        PlansManager.shared.setPlanCompleted(planId: plan.id, date: viewModel.selectedDate, isComplete: view.isChecked)
    }
    
    func checkmarkViewTapped(view: FoodCheckmarkView)
    {
        guard let food = view.food,
              let plan = PlansManager.shared.getFirstFoodPlan(withId: food.id, shouldFilterForToday: false) else
        {
            assertionFailure("TodayViewController-checkmarkViewTapped: FoodCheckmarkView didn't have a food or can't get food's plan")
            return
        }
        let storyboard = UIStoryboard(name: "TodayTab", bundle: nil)
        let activityDetailsVC = storyboard.instantiateViewController(identifier: "ActivityDetailsViewController") as! ActivityDetailsViewController
        activityDetailsVC.hidesBottomBarWhenPushed = true
        let planToRemove = PlansManager.shared.getFirstFoodPlan(withId: food.id, shouldFilterForToday: true)
        activityDetailsVC.setup(model: food.getActivityDetailsModel(planId: planToRemove?.id ?? plan.id), shouldShowRemovePlan: planToRemove != nil)
        
        analytics.log(event: .foodShown(foodId: food.id, foodName: food.title))
        
        navigationController?.pushViewController(activityDetailsVC, animated: true)
    }
    
    func animationComplete(view: FoodCheckmarkView)
    {
        viewModel.refreshLastWeekProgress()
        viewModel.refreshContactSuggestedFood()
        reloadUI()
        showGamificationCongratulationsViewIfNeeded()
    }
}

extension TodayViewController: TodayHeaderTableViewCellDelegate
{
    func onGoalTapped(goal: String)
    {
        resultsViewModel.refresh()
        guard let goalIndex = Goals.firstIndex(where: { $1.name == goal.lowercased() }) else
        {
            assertionFailure("TodayViewController-onGoalTapped: Couldn't find Goal with name: \(goal.lowercased())")
            return
        }
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
    
    func onCardChecked(id: Int, checked: Bool, type: CheckMarkCardType)
    {
        if type == .lifestyleRecommendation
        {
            let lifestyleRecommendationPlans = PlansManager.shared.getLifestyleRecommendationPlans()
            guard let plan = lifestyleRecommendationPlans.first(where: { $0.typeId == id }) else
            {
                assertionFailure("TodayViewController-onCardChecked: Couldn't find Lifestyle recommendation with id: \(id)")
                return
            }

            if plan.typeId == Constants.GET_SUPPLEMENTS_LIFESTYLE_RECOMMENDATION_ID
            {
                openSupplementQuiz()
            }
            else if (plan.typeId == -Constants.FUEL_AM_LIFESTYLE_RECOMMENDATION_ID) || (plan.typeId == -Constants.FUEL_PM_LIFESTYLE_RECOMMENDATION_ID)
            {
                openFormulation()
            }
            else if plan.typeId == -Constants.TAKE_A_TEST_LIFESTYLE_RECOMMENDATION_ID
            {
                mainTabBarController?.vesselButtonPressed()
            }
            else
            {
                PlansManager.shared.setPlanCompleted(planId: plan.id, date: viewModel.selectedDate, isComplete: true)
            }
        }
        else if type == .activity
        {
            let activities = PlansManager.shared.activities
            let activityPlans: [Plan] = PlansManager.shared.getActivityPlans(shouldFilterForToday: viewModel.isToday, shouldFilterForSelectedDate: viewModel.selectedDate)
            
            if let activity = activities.first(where: { $0.id == id }) //hardcoded activities
            {
                activity.isCompleted = true
                return
            }
            
            guard let plan = activityPlans.first(where: { $0.typeId == id }) else
            {
                assertionFailure("TodayViewController-onCardChecked: Couldn't find activity with id: \(id)")
                return
            }
            
            if let activity = activities.first(where: { $0.id == plan.typeId })
            {
                analytics.log(event: .activityComplete(activityId: activity.id, activityName: activity.title, completed: !plan.completed.contains(viewModel.selectedDate)))
            }
            
            PlansManager.shared.setPlanCompleted(planId: plan.id, date: viewModel.selectedDate, isComplete: checked)
        }
        else if type == .lesson
        {
            let lessons = LessonsManager.shared.todayLessons
            guard let lesson = lessons.first(where: { $0.id == id }) else
            {
                assertionFailure("TodayViewController-onCardChecked: Couldn't find lesson with id: \(id)")
                return
            }
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
    
    func animationComplete()
    {
        viewModel.refreshLastWeekProgress()
        viewModel.refreshContactSuggestedFood()
        reloadUI()
        showGamificationCongratulationsViewIfNeeded()
    }
    
    func onReminderTapped(id: Int, type: CheckMarkCardType)
    {
        RemindersManager.shared.reloadReminders()
        guard viewModel.showReminders else { return }
        if type == .activity
        {
            let activities = PlansManager.shared.activities
            let activityPlans = PlansManager.shared.getActivityPlans()
//            guard let plan = activityPlans.first(where: { $0.typeId == id }),
//                  let activity = activities.first(where: { $0.id == plan.typeId }) else
//            {
//                assertionFailure("TodayViewController-onReminderTapped: Can't find plan or activity with id: \(id)")
//                return
//            }
            
//            analytics.log(event: .addReminder(planId: plan.id, typeId: plan.typeId, planType: .activity))
            
            let reminders = RemindersManager.shared.getRemindersForPlan(planId: id)
            if reminders.count > 0
            {
                let storyboard = UIStoryboard(name: "Reminders", bundle: nil)
                let addReminderVC = storyboard.instantiateViewController(identifier: "RemindersViewController") as! RemindersViewController
                addReminderVC.hidesBottomBarWhenPushed = true
                addReminderVC.viewModel = RemindersViewModel(planId: id, reminders: reminders, activity: activities.first(where: {$0.id == id}))
                navigationController?.pushViewController(addReminderVC, animated: true)
            }
            else
            {
                let storyboard = UIStoryboard(name: "Reminders", bundle: nil)
                let addReminderVC = storyboard.instantiateViewController(identifier: "AddReminderViewController") as! AddReminderViewController
                addReminderVC.hidesBottomBarWhenPushed = true
                addReminderVC.viewModel = AddReminderViewModel(planId: id, activity: activities.first(where: {$0.id == id}))
                navigationController?.pushViewController(addReminderVC, animated: true)
            }
        }
        else if type == .lifestyleRecommendation
        {
            let lifestyleRecommendations = Storage.retrieve(as: LifestyleRecommendation.self)
            let lifestyleRecommendationPlans = PlansManager.shared.getLifestyleRecommendationPlans()
            guard let plan = lifestyleRecommendationPlans.first(where: { $0.typeId == id }),
                  let lifestyleRecommendation = lifestyleRecommendations.first(where: { $0.id == plan.typeId }),
                      plan.typeId != Constants.GET_SUPPLEMENTS_LIFESTYLE_RECOMMENDATION_ID else { return }

            analytics.log(event: .addReminder(planId: plan.id, typeId: plan.typeId, planType: .reagentLifestyleRecommendation))
            
            let reminders = RemindersManager.shared.getRemindersForPlan(planId: plan.id)
            if reminders.count > 0
            {
                let storyboard = UIStoryboard(name: "Reminders", bundle: nil)
                let addReminderVC = storyboard.instantiateViewController(identifier: "RemindersViewController") as! RemindersViewController
                addReminderVC.hidesBottomBarWhenPushed = true
                addReminderVC.viewModel = RemindersViewModel(planId: plan.id, reminders: reminders, lifestyleRecommendation: lifestyleRecommendation)
                navigationController?.pushViewController(addReminderVC, animated: true)
            }
            else
            {
                let storyboard = UIStoryboard(name: "Reminders", bundle: nil)
                let addReminderVC = storyboard.instantiateViewController(identifier: "AddReminderViewController") as! AddReminderViewController
                addReminderVC.hidesBottomBarWhenPushed = true
                addReminderVC.viewModel = AddReminderViewModel(planId: plan.id, lifestyleRecommendation: lifestyleRecommendation)
                navigationController?.pushViewController(addReminderVC, animated: true)
            }
        }
    }
}

extension TodayViewController: ProgressDayViewDelegate
{
    func onProgressDayTapped(date: String)
    {
        viewModel.selectedDate = date
        viewModel.refreshContactSuggestedFood()
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
