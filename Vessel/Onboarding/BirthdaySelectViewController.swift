//
//  BirthdaySelectViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 3/6/22.
//  Based on Onboarding Flow: https://www.notion.so/vesselhealth/Onboarding-79efd903aaf349098bf4e972bd9292cb

import UIKit

class BirthdaySelectViewController: UIViewController
{
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var checkmarkView: SelectionCheckmarkView!
    
    let minAge = Constants.MIN_AGE
    let averageAge = Constants.AVERAGE_AGE
    let maxAge = Constants.MAX_AGE
    private let calendar = Calendar.current
    private var minDateComponents = DateComponents()
    private var maxDateComponents = DateComponents()
    private var maxDate = Date()
    private var minDate = Date()
    var viewModel: OnboardingViewModel?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setDatePickerMinMaxValues()
        setDatePickerInitialValue()
        checkmarkView.defaultText = NSLocalizedString("I prefer not to say", comment: "")
    }
    
    private func setDatePickerInitialValue()
    {
        // set the initial year to current year - averageAge
        var dateComponents = calendar.dateComponents([.day, .month, .year], from: Date())
        
        if let year = dateComponents.year
        {
            dateComponents.year  = year - averageAge
        }
        if let date = calendar.date(from: dateComponents)
        {
            datePicker.setDate(date, animated: false)
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
        navigationController?.fadeOut()
    }
    
    @IBAction func privacyPolicyButton()
    {
        openInSafari(url: Constants.privacyPolicyURL)
    }
    
    @IBAction func next()
    {
        if checkmarkView.isChecked
        {
            //user prefers not to share birth date
            viewModel?.setBirthDate(birthdate: nil)
        }
        else
        {
            viewModel?.setBirthDate(birthdate: datePicker.date)
        }
        
        let vc = OnboardingViewModel.NextViewController()
        navigationController?.fadeTo(vc)
    }
}
