//
//  BirthdaySelectViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 3/6/22.
//

import UIKit

class BirthdaySelectViewController: UIViewController
{
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var checkmarkView: SelectionCheckmarkView!
    
    let minAge = 18
    let maxAge = 100
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
    }
    
    private func setDatePickerInitialValue()
    {
        // set the initial year to current year - minAge
        var dateComponents = calendar.dateComponents([.day, .month, .year], from: Date())
        
        if let year = dateComponents.year
        {
            dateComponents.year  = year - minAge
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
        if let contact = Contact.main()
        {
            if checkmarkView.isChecked
            {
                contact.birth_date = nil
            }
            else
            {
                let formatter = DateFormatter()
                formatter.dateFormat = Constants.SERVER_DATE_FORMAT
                let strDate = formatter.string(from: datePicker.date)
                contact.birth_date = strDate
            }
            ObjectStore.shared.ClientSave(contact)
        }
        
        let vc = OnboardingNextViewController()
        //{
            //navigationController?.pushViewController(vc, animated: true)
            navigationController?.fadeTo(vc)
        /*}
        else
        {
            self.navigationController?.popToRootViewController(animated: true)
            Server.shared.logOut()
        }*/
    }
    
}
