//
//  RemindersViewController.swift
//  Vessel
//
//  Created by Nicolas Medina on 2/2/23.
//

import UIKit

class RemindersViewController: UIViewController, VesselScreenIdentifiable
{
    // MARK: - Views
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabeL: UILabel!
    @IBOutlet private weak var saveButton: BounceButton!
    @IBOutlet private weak var emptyRemindersLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
    var flowName: AnalyticsFlowName = .remindersFlow
    @Resolved var analytics: Analytics
    var viewModel: RemindersViewModel!
    
    // MARK: - UIViewController lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()

        setupUI()
    }
    
    @IBAction func back()
    {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addAnotherReminder()
    {
        if let typeId = viewModel.typeId, let type = viewModel.type
        {
            analytics.log(event: .addReminder(planId: viewModel.planId, typeId: typeId, planType: type))
        }
        
        let storyboard = UIStoryboard(name: "Reminders", bundle: nil)
        let addReminderVC = storyboard.instantiateViewController(identifier: "AddReminderViewController") as! AddReminderViewController
        addReminderVC.hidesBottomBarWhenPushed = true
        addReminderVC.viewModel = AddReminderViewModel(planId: viewModel.planId, food: viewModel.food, activity: viewModel.activity)
        addReminderVC.delegate = self
        navigationController?.pushViewController(addReminderVC, animated: true)
    }
    
    @IBAction func onSave()
    {
        if let typeId = viewModel.typeId, let type = viewModel.type
        {
            analytics.log(event: .saveReminders(planId: viewModel.planId, typeId: typeId, planType: type))
        }
        navigationController?.popViewController(animated: true)
    }
}

extension RemindersViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return viewModel.reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.isFood ? "RemindersTableViewCell" : "ShortRemindersTableViewCell", for: indexPath) as? RemindersTableViewCell else
        {
            assertionFailure("RemindersViewController-tableViewCellForRowAt: Unable to dequeue cell with identifier RemindersTableViewCell")
            return UITableViewCell()
        }
        let reminder = viewModel.reminders[indexPath.row]
        cell.setup(planId: reminder.planId, reminder: reminder, delegate: self, food: viewModel.food, activity: viewModel.activity)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if viewModel.isFood
        {
            return 216.0
        }
        else
        {
            return 156.0
        }
    }
}

private extension RemindersViewController
{
    func setupUI()
    {
        titleLabel.text = viewModel.title
        subtitleLabeL.text = viewModel.subtitle
        setupImageView()
        reloadUI()
        saveButton.isHidden = viewModel.reminders.count == 0
    }
    
    func setupImageView()
    {
        guard let imageUrl = viewModel.imageUrl,
              let url = URL(string: imageUrl) else { return }
        backgroundImageView.kf.setImage(with: url)
    }
    
    func reloadUI()
    {
        emptyRemindersLabel.isHidden = viewModel.reminders.count > 0
        saveButton.isHidden = viewModel.reminders.count == 0
        tableView.reloadData()
    }
}

extension RemindersViewController: RemindersTableViewCellDelegate
{
    func onQuantityIncreased(reminderId: Int)
    {
        viewModel.increaseQuantity(to: reminderId)
        tableView.reloadData()
    }
    
    func onQuantityDecreased(reminderId: Int)
    {
        viewModel.decreaseQuantity(to: reminderId)
        tableView.reloadData()
    }
    
    func onDayTapped(reminderId: Int, day: Int)
    {
        viewModel.toggleSelectedDay(to: reminderId, day: day)
        tableView.reloadData()
    }
    
    func onReminderRemove(reminderId: Int)
    {
        viewModel.reminderToRemove = reminderId
        GenericAlertViewController.presentAlert(in: self, type: .titleSubtitleButtons(title: GenericAlertLabelInfo(title: NSLocalizedString("Are you sure?", comment: ""), alignment: .left),
                                                                                      subtitle: GenericAlertLabelInfo(title: NSLocalizedString("Are you sure you want to remove this reminder?", comment: ""), height: 100.0),
                                                                                      buttons: [
                                                                                        GenericAlertButtonInfo(label: GenericAlertLabelInfo(title: NSLocalizedString("Remove", comment: "")), type: .dark),
                                                                                        GenericAlertButtonInfo(label: GenericAlertLabelInfo(title: NSLocalizedString("Keep it", comment: "")), type: .clear),
                                                                                      ]),
                                                background: .green,
                                                showCloseButton: true,
                                                alignment: .bottom,
                                                animation: .modal,
                                                delegate: self)
    }
}

extension RemindersViewController: GenericAlertDelegate
{
    func onAlertButtonTapped(_ alert: GenericAlertViewController, index: Int, alertDescription: String)
    {
        if let reminderToRemove = viewModel.reminderToRemove, index == 0
        {
            if let typeId = viewModel.typeId, let type = viewModel.type
            {
                analytics.log(event: .reminderRemoved(reminderId: reminderToRemove, planId: viewModel.planId, typeId: typeId, planType: type))
            }
            viewModel.removeReminder(with: reminderToRemove)
        }
        
        viewModel.reminderToRemove = nil
        reloadUI()
    }
}

extension RemindersViewController: AddReminderViewControllerDelegate
{
    func onReminderAdded(reminder: Reminder)
    {
        viewModel.reminders.append(reminder)
        RemindersManager.shared.reloadReminders()
        tableView.reloadData()
    }
}
