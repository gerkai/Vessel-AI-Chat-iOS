//
//  BirthdaySelectViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 3/6/22.
//  Based on Onboarding Flow: https://www.notion.so/vesselhealth/Onboarding-79efd903aaf349098bf4e972bd9292cb

import UIKit

class BirthdaySelectViewController: UIViewController, VesselScreenIdentifiable
{
    // MARK: - Views
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var checkmarkView: SelectionCheckmarkView!
    @IBOutlet weak var pickerContainer: UIView!
    
    // MARK: - Logic
    var viewModel = BirthdaySelectViewModel()
    var coordinator: OnboardingCoordinator?
    
    @Resolved internal var analytics: Analytics
    let flowName: AnalyticsFlowName = .onboardingFlow
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("📖 did load \(self)")
        }
        
        setDatePickerMinMaxValues()
        setDatePickerInitialValue()
        checkmarkView.defaultText = NSLocalizedString("I prefer not to say", comment: "")
    }
    
    deinit
    {
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("📘 deinit \(self)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        checkmarkView.delegate = self
    }
    
    // MARK: - Initialization
    private func setDatePickerInitialValue()
    {
        let result = viewModel.getBirthDate()
        datePicker.setDate(result.date, animated: false)
        checkmarkView.isChecked = result.preferNotToSay
        if result.preferNotToSay
        {
            pickerContainer.alpha = 0.0
        }
    }
    
    private func setDatePickerMinMaxValues ()
    {
        viewModel.minDateComponents = viewModel.calendar.dateComponents([.day, .month, .year], from: Date())
        viewModel.maxDateComponents = viewModel.calendar.dateComponents([.day, .month, .year], from: Date())
        if let year = viewModel.minDateComponents.year,
           let month = viewModel.minDateComponents.month,
           let day = viewModel.minDateComponents.day
        {
            viewModel.minDateComponents.year = year - viewModel.minAge
            viewModel.minDateComponents.month = month
            viewModel.minDateComponents.day = day
            if let date = viewModel.calendar.date(from: viewModel.minDateComponents)
            {
                viewModel.maxDate = date
            }
        }
        if let year = viewModel.maxDateComponents.year
        {
            viewModel.maxDateComponents.year = abs(viewModel.maxAge - year)
            if let date = viewModel.calendar.date(from: viewModel.maxDateComponents)
            {
                viewModel.minDate = date
            }
        }
        datePicker.minimumDate = viewModel.minDate
        datePicker.maximumDate = viewModel.maxDate
    }
    
    // MARK: - Actions
    @IBAction func onBackTapped()
    {
        viewModel.setBirthDate(birthDate: datePicker.date, preferNotToSay: checkmarkView.isChecked)
        coordinator?.backup()
        checkmarkView.delegate = nil
    }
    
    @IBAction func onPrivacyPolicyTapped()
    {
        openInSafari(url: Constants.privacyPolicyURL)
    }
    
    @IBAction func onNextTapped()
    {
        checkmarkView.delegate = nil
        viewModel.setBirthDate(birthDate: datePicker.date, preferNotToSay: checkmarkView.isChecked)
        
        coordinator?.pushNextViewController()
    }
}

//MARK: - SelectionCheckmarkView Delegate
extension BirthdaySelectViewController: SelectionCheckmarkViewDelegate
{
    func didTapCheckmark(_ isChecked: Bool)
    {
        var pickerAlpha = 1.0
        if isChecked
        {
            pickerAlpha = 0.0
        }
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .beginFromCurrentState)
        {
            if pickerAlpha == 1.0
            {
                self.pickerContainer.isHidden = false
            }
            else
            {
                self.pickerContainer.isHidden = true
            }
            self.pickerContainer.alpha = pickerAlpha
        }
        completion:
        { _ in
        }
    }
}
