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
    @IBOutlet private weak var lockoutView: UIView!
    
    // MARK: - Model
    private var viewModel = TodayViewModel()
    private let resultsViewModel = ResultsTabViewModel()
    private var didLayout = false
    private var tableViewOffset: CGFloat?
    
    @Resolved internal var analytics: Analytics
    let flowName: AnalyticsFlowName = .todayTabFlow
    
    // MARK: - UIViewController Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        lockoutView.isHidden = !viewModel.isEmpty
//        view.bringSubviewToFront(lockoutView)
        resultsViewModel.refresh()
        
        //get notified when new foods, plans or results comes in from After Test Flow
        NotificationCenter.default.addObserver(self, selector: #selector(self.dataUpdated(_:)), name: .newDataArrived, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        didLayout = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.scrollViewDidScroll(self.tableView)
        })
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        handleLockoutView()
        reloadUI()
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
            //if the new data is a Result then refresh the chart and tests/goals
            if type == String(describing: Result.self)
            {
                viewModel.refresh()
                handleLockoutView()
            }
            else if type == String(describing: Food.self) || type == String(describing: Plan.self)
            {
                reloadUI()
            }
        }
    }
    
    func handleLockoutView()
    {
        if viewModel.isEmpty
        {
            lockoutView.isHidden = false
        }
        else
        {
            lockoutView.isHidden = true
        }
    }
    
    private func reloadUI()
    {
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
        viewModel.sections[indexPath.section].cells[indexPath.row].height + (viewModel.sections[indexPath.section] == viewModel.sections.last ? tableViewOffset ?? 0.0 : ViewConstants.TABLE_VIEW_SPACING)
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
        case .sectionTitle(let icon, let name):
            guard let cell = cell as? TodaySectionTitleTableViewCell else { fatalError("Can't dequeue cell TodaySectionTitleTableViewCell from tableView in TodayViewController") }
            cell.setup(iconName: icon, title: name)
        case .foodDetails(let foods):
            guard let cell = cell as? TodayFoodDetailsSectionTableViewCell else { fatalError("Can't dequeue cell TodayFoodDetailsSectionTableViewCell from tableView in TodayViewController") }
            cell.setup(foods: foods, delegate: self)
        case .waterDetails(let glassesNumber, let checkedGlasses):
            guard let cell = cell as? TodayWaterDetailsSectionTableViewCell else { fatalError("Can't dequeue cell TodayWaterDetailsSectionTableViewCell from tableView in TodayViewController") }
            cell.setup(glassesNumber: glassesNumber, checkedGlasses: checkedGlasses, delegate: self)
        case .checkMarkCard(let title, let subtitle, let description, let backgroundImage, let completed):
            guard let cell = cell as? TodayCheckMarkCardTableViewCell else { fatalError("Can't dequeue cell TodayCheckMarkCardTableViewCell from tableView in TodayViewController") }
            cell.setup(title: title, subtitle: subtitle, description: description, backgroundImage: backgroundImage, completed: completed)
        case .footer:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        guard let section = viewModel.sections[safe: indexPath.section] else { return }
        switch section
        {
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
            waterDetailsVC.drinkedWaterGlasses = viewModel.drinkedWaterGlasses ?? 0
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

extension TodayViewController: UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        guard didLayout == true else { return }
        
        if tableViewOffset == nil
        {
            tableViewOffset = tableView.frame.height - tableView.contentSize.height
            reloadUI()
        }
        
        if tableView.contentOffset.y <= 0
        {
            view.backgroundColor = .offwhite
        }
        else
        {
            view.backgroundColor = .codGray
        }
    }
}

extension TodayViewController: FoodCheckmarkViewDelegate
{
    func checkmarkTapped(view: FoodCheckmarkView)
    {
        guard let plan = PlansManager.shared.plans.first(where: { $0.foodId == view.food?.id }) else { return }
        Server.shared.completePlan(planId: plan.id, toggleData: TogglePlanData(date: Date(), completed: view.isChecked))
        { [weak self] togglePlanData in
            guard let self = self else { return }
            PlansManager.shared.togglePlanCompleted(planId: plan.id, date: togglePlanData.date, completed: togglePlanData.completed)
            guard let cell = self.tableView.cellForRow(at: IndexPath(row: 1, section: TodayViewSection.food(foods: []).sectionIndex)) as? TodayFoodDetailsSectionTableViewCell else { return }
            cell.updateCheckedFoods()
        } onFailure: { error in
            guard let cell = self.tableView.cellForRow(at: IndexPath(row: 1, section: TodayViewSection.food(foods: []).sectionIndex)) as? TodayFoodDetailsSectionTableViewCell else { return }
            cell.updateCheckedFoods()
        }
    }
    
    func checkmarkViewTapped(view: FoodCheckmarkView)
    {
        guard let food = view.food else { return }
        let storyboard = UIStoryboard(name: "TodayTab", bundle: nil)
        let activityDetailsVC = storyboard.instantiateViewController(identifier: "ActivityDetailsViewController") as! ActivityDetailsViewController
        activityDetailsVC.hidesBottomBarWhenPushed = true
        activityDetailsVC.setup(food: food)
        navigationController?.pushViewController(activityDetailsVC, animated: true)
    }
}

extension TodayViewController: TodayHeaderTableViewCellDelegate
{
    func onGoalTapped(goal: String)
    {
        guard let goalIndex = Goals.firstIndex(where: { $1.name == goal.lowercased() }) else { return }
        let id = Goals[goalIndex].key.rawValue
        
        let goalID = Goal.ID(rawValue: id)!
        let vc = GoalDetailsViewController.initWith(goal: goalID, viewModel: resultsViewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}
