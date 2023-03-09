//
//  RemindersTableViewCell.swift
//  Vessel
//
//  Created by Nicolas Medina on 2/3/23.
//

import UIKit

protocol RemindersTableViewCellDelegate: AnyObject
{
    func onQuantityIncreased(reminderId: Int)
    func onQuantityDecreased(reminderId: Int)
    func onDayTapped(reminderId: Int, day: Int)
    func onReminderRemove(reminderId: Int)
}

class RemindersTableViewCell: UITableViewCell
{
    // MARK: - View
    @IBOutlet private weak var quantityLabel: UILabel?
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var daysOfWeekStackView: UIStackView!
    @IBOutlet private weak var decreaseQuantityButton: BounceButton?
    
    private var reminderId: Int!
    weak var delegate: RemindersTableViewCellDelegate?
    
    func setup(planId: Int, reminder: Reminder, delegate: RemindersTableViewCellDelegate?, food: Food? = nil, activity: Tip? = nil)
    {
        self.delegate = delegate
        self.reminderId = reminder.id
        
        quantityLabel?.text = "\(reminder.quantity) \(food?.servingUnit ?? "") / \(NSLocalizedString("day", comment: ""))"
        timeLabel.text = reminder.timeOfDay.convertTo12HourFormat()
        
        decreaseQuantityButton?.isHidden = reminder.quantity == 1
        
        setupDaysStackView(reminder: reminder)
    }
    
    private func setupDaysStackView(reminder: Reminder)
    {
        daysOfWeekStackView.backgroundColor = .clear
        let dayStrings = Constants.DAYS_OF_THE_WEEK.map({ return String($0.firstUppercased) })
        for (index, view) in (daysOfWeekStackView.arrangedSubviews as? [ProgressDayView] ?? []).enumerated()
        {
            let selection = reminder.dayOfWeek.contains(index)
            view.setup(dateString: "\(index)", dayString: dayStrings[index], isSelected: selection, delegate: self)
        }
    }
    
    // MARK: - Actions
    @IBAction func onRemoveReminder()
    {
        delegate?.onReminderRemove(reminderId: reminderId)
    }
    
    @IBAction func increaseQuantity()
    {
        delegate?.onQuantityIncreased(reminderId: reminderId)
    }
    
    @IBAction func decreaseQuantity()
    {
        delegate?.onQuantityDecreased(reminderId: reminderId)
    }
}

extension RemindersTableViewCell: ProgressDayViewDelegate
{
    func onProgressDayTapped(date: String)
    {
        guard let day = Int(date) else
        {
            assertionFailure("AddReminderViewController-onProgressDayTapped: Can't parse date to Int")
            return
        }
        delegate?.onDayTapped(reminderId: reminderId, day: day)
    }
}
