//
//  MoreViewController.swift
//  Vessel
//
//  Created by Nicolas Medina on 7/25/22.
//

import UIKit

class MoreViewController: UIViewController
{
    // MARK: Views
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var versionLabel: UILabel!
    
    @Resolved private var analytics: Analytics
    
    // MARK: Model
    private let viewModel = MoreViewModel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        versionLabel.text = viewModel.versionString
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        analytics.log(event: .viewedPage(screenName: .moreTab))
    }
    
    // MARK: - Actions
    @IBAction func onLeftButton()
    {
        viewModel.key.append(0)
        viewModel.key.remove(at: 0)
    }
    
    @IBAction func onRightButton()
    {
        viewModel.key.append(1)
        viewModel.key.remove(at: 0)
    }
}

extension MoreViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return viewModel.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let option = viewModel.options[safe: indexPath.row],
              let cell = tableView.dequeueReusableCell(withIdentifier: "MoreTabCell", for: indexPath) as? MoreTabCell else
        {
            assertionFailure("MoreTabCell dequed in a bad state in MoreViewController cellForRowAt indexPath")
            return UITableViewCell()
        }
        cell.setup(title: option.text, iconName: option.icon)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80.0
    }
}

extension MoreViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        guard let option = viewModel.options[safe: indexPath.row] else
        {
            assertionFailure("MoreTabCell dequed in a bad state in MoreViewController didSelectRowAt indexPath")
            return
        }
        
        switch option
        {
        case .myAccount:
            let storyboard = UIStoryboard(name: "MoreTab", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "MyAccountViewController") as! MyAccountViewController
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case .takeATest:
            mainTabBarController?.vesselButtonPressed()
        case .orderCards:
            openInSafari(url: "https://vesselhealth.com/membership")
        case .customSupplements:
            openInSafari(url: "https://vesselhealth.com/pages/new-quiz")
        case .chatWithNutritionist:
            tabBarController?.selectedIndex = 3
        case .backedByScience:
            openInSafari(url: "https://vesselhealth.com/pages/backed-by-science")
        case .support:
            if viewModel.key == viewModel.lock && !viewModel.options.contains(.debug)
            {
                viewModel.addDebugMenu()
                tableView.reloadData()
            }
            else
            {
                openInSafari(url: "https://help.vesselhealth.com")
            }
        case .debug:
            let storyboard = UIStoryboard(name: "MoreTab", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "DebugMenuViewController") as! DebugMenuViewController
            vc.hidesBottomBarWhenPushed = false
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
