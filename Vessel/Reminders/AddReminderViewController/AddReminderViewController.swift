//
//  AddReminderViewController.swift
//  Vessel
//
//  Created by Nicolas Medina on 2/1/23.
//

import UIKit

protocol AddReminderViewControllerDelegate: AnyObject
{
    func onReminderAdded(reminder: Reminder)
}

class AddReminderViewController: UIViewController, VesselScreenIdentifiable
{
    // MARK: - Views
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabeL: UILabel!
    @IBOutlet private weak var addAReminderLabel: UILabel!
    @IBOutlet private weak var howMuchTitleLabel: UILabel!
    @IBOutlet private weak var howMuchView: UIView!
    @IBOutlet private weak var howMuchTextLabel: UILabel!
    @IBOutlet private weak var decreaseQuantityButton: BounceButton!
    @IBOutlet private var whatTimeButtons: [BounceButton]!
    @IBOutlet private weak var pickExactTimeButton: BounceButton!
    @IBOutlet private weak var whatTimeViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var exactTimeViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var daysOfWeekLabel: UILabel!
    @IBOutlet private weak var daysOfWeekStackView: UIStackView!
    @IBOutlet private weak var skipButton: BounceButton!
    
    var flowName: AnalyticsFlowName = .remindersFlow
    @Resolved var analytics: Analytics
    var viewModel: AddReminderViewModel!
    weak var delegate: AddReminderViewControllerDelegate?
    
    // MARK: - UIViewController lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Actions
    @IBAction func back()
    {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTimeSelected(_ sender: BounceButton)
    {
        guard let text = sender.titleLabel?.text else
        {
            assertionFailure("AddReminderViewController-onTimeSelected: Button has no text")
            return
        }
        viewModel.selectTime(time: text)
        reloadUI()
    }
    
    @IBAction func increaseQuantity()
    {
        viewModel.increaseQuantity()
        reloadUI()
    }
    
    @IBAction func decreaseQuantity()
    {
        viewModel.decreaseQuantity()
        reloadUI()
    }
    
    @IBAction func onPickAnExactTime()
    {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        NSLayoutConstraint.activate([
            pickerView.heightAnchor.constraint(equalToConstant: 200)
        ])
        pickerView.backgroundColor = UIColor.willowGreen
        GenericAlertViewController.presentAlert(in: self,
                                                type: .titleCustomViewButton(title: GenericAlertLabelInfo(title: NSLocalizedString("Pick an exact time", comment: "")),
                                                                             view: pickerView, button: GenericAlertButtonInfo(label: GenericAlertLabelInfo(title: NSLocalizedString("Continue", comment: "")),
                                                                                                                              type: .dark)),
                                                background: .green,
                                                showCloseButton: true,
                                                alignment: .bottom,
                                                animation: .modal,
                                                shouldCloseWhenTappedOutside: false,
                                                delegate: self)
    }
    
    @IBAction func addToPlan()
    {
        guard !viewModel.selectedTime.isEmpty else
        {
            UIView.showError(text: "", detailText: NSLocalizedString("Please select a time", comment: ""))
            return
        }
        
        guard viewModel.hasSelecteedWeekdays else
        {
            UIView.showError(text: "", detailText: NSLocalizedString("Please select a day of the week", comment: ""))
            return
        }
        
        viewModel.saveReminder()
        delegate?.onReminderAdded(reminder: viewModel.reminder)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSkip()
    {
        if let typeId = viewModel.typeId, let type = viewModel.type
        {
            analytics.log(event: .reminderSkipped(planId: viewModel.planId, typeId: typeId, planType: type))
        }
        navigationController?.popViewController(animated: true)
    }
}

private extension AddReminderViewController
{
    func setupUI()
    {
        titleLabel.text = viewModel.title
        subtitleLabeL.text = viewModel.subtitle
        if delegate != nil
        {
            addAReminderLabel.text = NSLocalizedString("Add another reminder", comment: "")
            skipButton.isHidden = true
        }
        setupImageView()
        reloadUI()
    }
    
    func setupImageView()
    {
        guard let imageUrl = viewModel.imageUrl,
              let url = URL(string: imageUrl) else { return }
        backgroundImageView.kf.setImage(with: url)
    }
    
    func setupDaysStackView()
    {
        daysOfWeekStackView.backgroundColor = .clear
        daysOfWeekLabel.text = viewModel.selectedWeekdays
        let dayStrings = Constants.DAYS_OF_THE_WEEK.compactMap(
            {
                if let first = $0.first
                {
                    return String(first)
                }
                return nil
            })
        for (index, view) in (daysOfWeekStackView.arrangedSubviews as? [ProgressDayView] ?? []).enumerated()
        {
            let selection = viewModel.selection[index]
            view.setup(dateString: "\(index)", dayString: dayStrings[index], isSelected: selection, delegate: self)
        }
    }
    
    func setupHowMuch()
    {
        howMuchView.isHidden = !viewModel.shouldShowHowMuchSection
        howMuchTitleLabel.isHidden = !viewModel.shouldShowHowMuchSection
        howMuchTextLabel.text = viewModel.quantityText
        decreaseQuantityButton.isHidden = viewModel.decreaseButtonIsHidden()
    }
    
    func setupWhatTime()
    {
        for button in whatTimeButtons
        {
            if viewModel.selectedTime == button.titleLabel?.text
            {
                button.layer.borderColor = UIColor.black.cgColor
                button.layer.borderWidth = 1.0
            }
            else
            {
                button.layer.borderColor = UIColor.clear.cgColor
                button.layer.borderWidth = 0.0
            }
        }
        
        let pickAnExactTimeString = NSLocalizedString("Pick an exact time", comment: "")
        if viewModel.shouldShowExactTime
        {
            pickExactTimeButton.setTitle(viewModel.selectedTime.isEmpty ? pickAnExactTimeString : viewModel.selectedTime, for: .normal)
            pickExactTimeButton.titleLabel?.font = Constants.FontTitleMain16
            pickExactTimeButton.setTitleColor(.white, for: .normal)
            pickExactTimeButton.backgroundColor = .blackAlpha7
            whatTimeViewHeightConstraint.constant = 112
            exactTimeViewHeightConstraint.constant = 60
        }
        else
        {
            pickExactTimeButton.setTitle(pickAnExactTimeString, for: .normal)
            pickExactTimeButton.titleLabel?.font = Constants.FontTitleMain12
            pickExactTimeButton.setTitleColor(.black, for: .normal)
            pickExactTimeButton.backgroundColor = .whiteAlpha7

            whatTimeViewHeightConstraint.constant = 90
            exactTimeViewHeightConstraint.constant = 38
        }
        view.layoutIfNeeded()
    }
    
    func reloadUI()
    {
        setupDaysStackView()
        setupHowMuch()
        setupWhatTime()
    }
}

extension AddReminderViewController: ProgressDayViewDelegate
{
    func onProgressDayTapped(date: String)
    {
        guard let int = Int(date) else
        {
            assertionFailure("AddReminderViewController-onProgressDayTapped: Can't parse date to Int")
            return
        }
        viewModel.toggleDayOfWeek(int)
        reloadUI()
    }
}

extension AddReminderViewController: UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        switch component
        {
        case 0:
            return 12
        case 1:
            return 60
        case 2:
            return 2
        default:
            return 0
        }
    }
}

extension AddReminderViewController: UIPickerViewDelegate
{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        switch component
        {
        case 0:
            return row < 9 ? "0\(row + 1)" : "\(row + 1)"
        case 1:
            return row <= 9 ? "0\(row)" : "\(row)"
        case 2:
            return row == 0 ? Constants.AM_SYMBOL : Constants.PM_SYMBOL
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let label = (view as? UILabel) ?? UILabel()
        if component == 2
        {
            label.font = Constants.FontPickerSemibold22
        }
        else
        {
            label.font = Constants.FontPicker22
        }
        label.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        label.textAlignment = .center
        return label
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        let selectedRow = pickerView.view(forRow: row, forComponent: component) as! UILabel
        selectedRow.font = Constants.FontPickerSemibold22
        let firstRow = pickerView.view(forRow: pickerView.selectedRow(inComponent: 0), forComponent: 0) as? UILabel
        let secondRow = pickerView.view(forRow: pickerView.selectedRow(inComponent: 1), forComponent: 1) as? UILabel
        let thirdRow = pickerView.view(forRow: pickerView.selectedRow(inComponent: 2), forComponent: 2) as? UILabel
        
        viewModel.temporarySelectedExactTime = "\(firstRow?.text ?? "01"):\(secondRow?.text ?? "00") \(thirdRow?.text ?? Constants.AM_SYMBOL)"
    }
}

extension AddReminderViewController: GenericAlertDelegate
{
    func onAlertButtonTapped(_ alert: GenericAlertViewController, index: Int, alertDescription: String)
    {
        guard let temporarySelectedExactTime = viewModel.temporarySelectedExactTime else
        {
            return
        }
        viewModel.selectTime(time: temporarySelectedExactTime)
        reloadUI()
    }
    
    func onAlertDismissed(_ alert: GenericAlertViewController, alertDescription: String)
    {
        viewModel.temporarySelectedExactTime = nil
    }
}
