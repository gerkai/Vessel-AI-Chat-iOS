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
    
    // MARK: Model
    private let viewModel = MyAccountViewModel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        if isMovingFromParent
        {
            mainViewController?.hideVesselButton(false)
        }
    }
    
    // MARK: - Actions
    @IBAction func onBackButtonPressed(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logOut(_ sender: Any)
    {
        Server.shared.logOut()
        Contact.reset()
        let story = UIStoryboard(name: "Login", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "Welcome")
        
        //set Welcome screen as root viewController. This causes MainViewController to get deallocated.
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}

extension MyAccountViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return viewModel.options.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard indexPath.row > 0 else
        {
            return tableView.dequeueReusableCell(withIdentifier: "MyAccountHeader", for: indexPath)
        }
        
        guard let option = viewModel.options[safe: indexPath.row - 1],
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
        guard indexPath.row > 0 else { return }
        guard let option = viewModel.options[safe: indexPath.row - 1] else
        {
            assertionFailure("MyAccountCell dequed in a bad state in MyAccountViewController didSelectRowAt indexPath")
            return
        }
        let storyboard = UIStoryboard(name: "MoreTab", bundle: nil)
        switch option
        {
        case .profile:
            let vc = storyboard.instantiateViewController(identifier: "EditProfileViewController") as! EditProfileViewController
            navigationController?.pushViewController(vc, animated: true)
        case .manageMyGoals:
            let vc = storyboard.instantiateViewController(identifier: "GoalsPreferencesViewController") as! GoalsPreferencesViewController
            navigationController?.pushViewController(vc, animated: true)
        case .manageMyDietOrAllergies:
            let vc = storyboard.instantiateViewController(identifier: "FoodPreferencesViewController") as! FoodPreferencesViewController
            navigationController?.pushViewController(vc, animated: true)
        case .manageMembership:
            openInSafari(url: "https://vesselhealth.com/account")
        }
    }
}
