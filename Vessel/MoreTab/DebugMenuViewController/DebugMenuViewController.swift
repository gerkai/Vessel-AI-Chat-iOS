//
//  DebugMenuViewController.swift
//  Vessel
//
//  Created by Nicolas Medina on 8/23/22.
//

import UIKit

protocol DebugMenuViewControllerDelegate: AnyObject
{
    func refresh()
}

class DebugMenuViewController: UIViewController, VesselScreenIdentifiable
{
    var flowName: AnalyticsFlowName = .moreTabFlow
    var delegate: DebugMenuViewControllerDelegate?
    
    @Resolved internal var analytics: Analytics
    
    // MARK: - View
    @IBOutlet private weak var tableView: UITableView!
    private let viewModel = DebugMenuViewModel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = NSLocalizedString("Debug Menu", comment: "")
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        if isMovingFromParent
        {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
}

extension DebugMenuViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return viewModel.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DebugMenuCell", for: indexPath) as? DebugMenuCell,
              let option = viewModel.options[safe: indexPath.row] else
        {
            return UITableViewCell()
        }
        
        cell.setup(title: option.title, turnedOn: option.isEnabled, delegate: self)
        cell.tag = option.rawValue
        return cell
    }
}

extension DebugMenuViewController: DebugMenuCellDelegate
{
    func onToggle(_ value: Bool, tag: Int)
    {
        guard let option = DebugMenuOption(rawValue: tag) else { return }
        if option.toggle() == true
        {
            delegate?.refresh()
        }
    }
}
