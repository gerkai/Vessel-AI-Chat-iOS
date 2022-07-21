//
//  BirthdaySelectViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 3/6/22.
//  Based on Onboarding Flow: https://www.notion.so/vesselhealth/Onboarding-79efd903aaf349098bf4e972bd9292cb

import UIKit

class BirthdaySelectViewController: OnboardingMVVMViewController, SelectionCheckmarkViewDelegate
{
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var checkmarkView: SelectionCheckmarkView!
    @IBOutlet weak var pickerContainer: UIView!
    
    let minAge = Constants.MIN_AGE
    let maxAge = Constants.MAX_AGE
    private let calendar = Calendar.current
    private var minDateComponents = DateComponents()
    private var maxDateComponents = DateComponents()
    private var maxDate = Date()
    private var minDate = Date()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setDatePickerMinMaxValues()
        setDatePickerInitialValue()
        checkmarkView.defaultText = NSLocalizedString("I prefer not to say", comment: "")
        checkmarkView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        // TODO: Add analytics for viewed page
    }
    
    private func setDatePickerInitialValue()
    {
        if let result = viewModel?.getBirthDate()
        {
            datePicker.setDate(result.date, animated: false)
            checkmarkView.isChecked = result.preferNotToSay
            if result.preferNotToSay
            {
                pickerContainer.alpha = 0.0
            }
        }
    }
    
    private func setDatePickerMinMaxValues ()
    {
        minDateComponents = calendar.dateComponents([.day, .month, .year], from: Date())
        maxDateComponents = calendar.dateComponents([.day, .month, .year], from: Date())
        if let year = minDateComponents.year
        {
            minDateComponents.year = year - minAge
            minDateComponents.month = 12
            minDateComponents.day = 31
            if let date = calendar.date(from: minDateComponents)
            {
                maxDate = date
            }
        }
        if let year = maxDateComponents.year
        {
            maxDateComponents.year = maxAge - year
            if let date = calendar.date(from: maxDateComponents)
            {
                minDate = date
            }
        }
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
    }
    
    @IBAction func back()
    {
        viewModel?.setBirthDate(birthDate: datePicker.date, preferNotToSay: checkmarkView.isChecked)
        viewModel?.backup()
        navigationController?.fadeOut()
    }
    
    @IBAction func privacyPolicyButton()
    {
        openInSafari(url: Constants.privacyPolicyURL)
    }
    
    @IBAction func next()
    {
        viewModel?.setBirthDate(birthDate: datePicker.date, preferNotToSay: checkmarkView.isChecked)
        
        let vc = OnboardingViewModel.NextViewController()
        navigationController?.fadeTo(vc)
    }
    
    //MARK: - SelectionCheckmarkView delegates
    func didTapCheckmark(_ isChecked: Bool)
    {
        var pickerAlpha = 1.0
        if isChecked
        {
            pickerAlpha = 0.0
        }
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .beginFromCurrentState)
        {
            self.pickerContainer.alpha = pickerAlpha
        }
        completion:
        { _ in
        }
    }
}
