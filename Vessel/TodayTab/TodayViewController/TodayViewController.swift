//
//  TodayViewController.swift
//  Vessel
//
//  Created by Nicolas Medina on 9/26/22.
//

import UIKit

class TodayViewController: UIViewController
{
    // MARK: - Constants
    private struct Constants
    {
        static let TABLE_VIEW_SPACING = 16.0
    }
    
    // MARK: - UI
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var backgroundViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var emptyView: UIView!
    
    // MARK: - Model
    private var viewModel = TodayViewModel()
    private var initialVerticalOffset: CGFloat?
    
    // MARK: - UIViewController Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        emptyView.isHidden = !viewModel.isEmpty
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
        viewModel.sections[indexPath.section].cells[indexPath.row].height + (viewModel.sections[indexPath.section] == viewModel.sections.last ? 0.0 : Constants.TABLE_VIEW_SPACING)
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
        case .checkMarkCard(let title, let subtitle, let description, let backgroundImage, let completed):
            guard let cell = cell as? TodayCheckMarkCardTableViewCell else { fatalError("Can't dequeue cell TodayCheckMarkCardTableViewCell from tableView in TodayViewController") }
            cell.setup(title: title, subtitle: subtitle, description: description, backgroundImage: backgroundImage, completed: completed)
        case .footer:
            return cell
        }
        return UITableViewCell()
    }
}

extension TodayViewController: UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if initialVerticalOffset == nil
        {
            initialVerticalOffset = scrollView.contentOffset.y
        }
        
        guard let initialVerticalOffset = initialVerticalOffset,
              scrollView.contentOffset.y - initialVerticalOffset <= 0 else { return }
        
        backgroundViewHeightConstraint.constant = view.safeAreaInsets.top + abs(scrollView.contentOffset.y - initialVerticalOffset)
        view.layoutIfNeeded()
    }
}
