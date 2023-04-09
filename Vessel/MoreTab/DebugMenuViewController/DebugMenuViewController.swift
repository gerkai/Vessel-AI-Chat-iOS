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
    @IBOutlet private weak var contactLabel: UILabel!
    
    private let viewModel = DebugMenuViewModel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = NSLocalizedString("Debug Menu", comment: "")
        contactLabel.text = viewModel.contactIDText()
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
            assertionFailure("DebugMenuViewController-tableViewCellForRowAt: Couldn't dequeue cell with identifier DebugMenuCell or option non existent for indexPath: \(indexPath)")
            return UITableViewCell()
        }
        
        cell.setup(title: option.title, turnedOn: option.isEnabled, showTextField: option.showTextField, delegate: self)
        cell.tag = option.rawValue
        return cell
    }
}

extension DebugMenuViewController: DebugMenuCellDelegate
{
    func onToggle(_ value: Bool, tag: Int, textFieldValue: String?)
    {
        guard let option = DebugMenuOption(rawValue: tag) else
        {
            assertionFailure("DebugMenuViewController-onToggle: Option non existent for tag: \(tag)")
            return
        }
        if option.toggle(value: textFieldValue) == true
        {
            delegate?.refresh()
        }
    }
}
