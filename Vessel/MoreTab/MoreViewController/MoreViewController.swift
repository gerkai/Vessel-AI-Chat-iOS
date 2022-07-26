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
    
    // MARK: Model
    private let viewModel = MoreViewModel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        versionLabel.text = viewModel.versionString
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
        cell.setup(title: option.text, imageName: option.icon)
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
        
        print("\(option.text)")
        switch option
        {
        case .myAccount:
            // TODO: Route to My Account
            break
        case .takeATest:
            // TODO: Route to Take a Test
            break
        case .orderCards:
            // TODO: Route to Order Cards
            break
        case .customSupplements:
            // TODO: Route to Custom Supplements
            break
        case .chatWithNutritionist:
            // TODO: Route to Chat with Nutritionist
            break
        case .backedByScience:
            // TODO: Route to Backed by Science
            break
        case .support:
            // TODO: Route to Support
            break
        }
    }
}
