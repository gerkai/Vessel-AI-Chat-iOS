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
    @IBOutlet private weak var emptyView: UIView!
    
    // MARK: - Model
    private var viewModel = TodayViewModel()
    private var didLayout = false
    private var tableViewOffset: CGFloat?
    
    @Resolved internal var analytics: Analytics
    let flowName: AnalyticsFlowName = .todayTabFlow
    
    // MARK: - UIViewController Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        emptyView.isHidden = !viewModel.isEmpty
        view.bringSubviewToFront(emptyView)
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
        tableView.reloadData()
    }
    
    // MARK: - Actions
    @IBAction func onTakeATest()
    {
        mainTabBarController?.vesselButtonPressed()
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
            cell.setup(name: name, goals: goals)
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
            waterDetailsVC.drinkedWaterGlasses = viewModel.drinkedWaterGlasses ?? 2
            waterDetailsVC.numberOfGlasses = viewModel.numberOfGlasses ?? 0
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
            tableView.reloadData()
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
