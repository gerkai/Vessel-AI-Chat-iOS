//
//  MyAccountViewController.swift
//  Vessel
//
//  Created by Nicolas Medina on 7/26/22.
//

import UIKit

class MyAccountViewController: UIViewController
{
    // MARK: - Views
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Model
    private let viewModel = MyAccountViewModel()
    
    // MARK: - Actions
    @IBAction func onBackButtonPressed(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logOut(_ sender: Any)
    {
        Server.shared.logOut()
        mainViewController?.navigationController?.popToRootViewController(animated: true)
    }
}

extension MyAccountViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return viewModel.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let option = viewModel.options[safe: indexPath.row],
              let cell = tableView.dequeueReusableCell(withIdentifier: "MyAccountCell", for: indexPath) as? MyAccountCell else
        {
            assertionFailure("MyAccountCell dequed in a bad state in MyAccountViewController cellForRowAt indexPath")
            return UITableViewCell()
        }
        cell.setup(title: option.title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80.0
    }
}

extension MyAccountViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        guard let option = viewModel.options[safe: indexPath.row] else
        {
            assertionFailure("MyAccountCell dequed in a bad state in MyAccountViewController didSelectRowAt indexPath")
            return
        }
        
        print("\(option.title)")
        switch option
        {
        case .profile:
            // TODO: Route to Profile
            break
        case .manageMyGoals:
            // TODO: Route to Manage my Goals
            break
        case .manageMyDietOrAllergies:
            // TODO: Route to Manage My Diet/Allergies
            break
        case .manageMembership:
            openInSafari(url: "https://vesselhealth.com/account")
        }
    }
}
