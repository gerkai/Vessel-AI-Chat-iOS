//
//  ChangePasswordViewController.swift
//  Vessel
//
//  Created by Nicolas Medina on 8/9/22.
//

import UIKit

class ChangePasswordViewController: UIViewController
{
    // MARK: - Views
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: Model
    private let viewModel = ChangePasswordViewModel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0)
    }
    
    // MARK: - Actions
    @IBAction func onBackButtonPressed(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSaveButtonPressed()
    {
        guard let oldPasswordCell = tableView.visibleCells[safe: 1] as? ChangePasswordCell,
              let newPasswordCell = tableView.visibleCells[safe: 2] as? ChangePasswordCell,
              let newPasswordConfirmationCell = tableView.visibleCells[safe: 3] as? ChangePasswordCell,
              let oldPasswordText = oldPasswordCell.text(),
              let newPasswordText = newPasswordCell.text(),
              let newPasswordConfirmationText = newPasswordConfirmationCell.text() else { return }

        viewModel.onChangePasswordSaved(oldPassword: oldPasswordText, newPassword: newPasswordText, newPasswordConfirmation: newPasswordConfirmationText) { [weak self] in
            guard let self = self else { return }
            GenericAlertViewController.presentAlert(in: self,
                                                    type: .imageTitleButton(image: UIImage(named: "LargeGreenCheck")!,
                                                                            title: GenericAlertLabelInfo(title: NSLocalizedString("Your password was successfully changed", comment: "Password changed success message"),
                                                                                                         font: UIFont(name: "BananaGrotesk-Semibold", size: 24.0),
                                                                                                         height: 60),
                                                                            button: GenericAlertButtonInfo(label: GenericAlertLabelInfo(title: NSLocalizedString("Got it", comment: "")),
                                                                                                           type: .dark)),
                                                    animation: .modal,
                                                    delegate: self)
        } errorCompletion: { error in
            UIView.showError(text: error.localizedDescription, detailText: "")
        }
    }
}

extension ChangePasswordViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return viewModel.options.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard indexPath.row > 0 else
        {
            return tableView.dequeueReusableCell(withIdentifier: "ChangePasswordHeader", for: indexPath)
        }
        
        guard let option = viewModel.options[safe: indexPath.row - 1],
              let cell = tableView.dequeueReusableCell(withIdentifier: "ChangePasswordCell", for: indexPath) as? ChangePasswordCell else
        {
            assertionFailure("ChangePasswordCell dequed in a bad state in ChangePasswordViewController cellForRowAt indexPath")
            return UITableViewCell()
        }
        cell.setup(placeholder: option.placeholder)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80.0
    }
}

extension ChangePasswordViewController: GenericAlertDelegate
{
    func onAlertDismissed(_ alert: GenericAlertViewController)
    {
        Server.shared.logOut()
        let story = UIStoryboard(name: "Login", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "Welcome")
        
        //set Welcome screen as root viewController. This causes MainViewController to get deallocated.
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}
