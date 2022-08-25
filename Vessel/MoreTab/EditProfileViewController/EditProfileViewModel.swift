//
//  EditProfileViewModel.swift
//  Vessel
//
//  Created by Nicolas Medina on 7/27/22.
//

import Foundation

class EditProfileViewModel
{
    // MARK: - Private variables
    private let contact = Contact.main()
    //private let contact: Contact.mockContact()
    
    // MARK: - Height PickerView
    var isMetric: Bool
    {
        //determine if we are using imperial or metric units
        Locale.current.usesMetricSystem
    }
    
    var shouldHidePassword: Bool
    {
        return contact?.loginType == .apple || contact?.loginType == .google
    }
    
    func heightForPickerView() -> (Int, Int)
    {
        if isMetric
        {
            if let heightCm = Double(height ?? "")
            {
                return (Int(heightCm), 0)
            }
            else
            {
                return (Constants.DEFAULT_HEIGHT, 0)
            }
        }
        else
        {
            if let heightString = height
            {
                let feetInches = heightString.replacingOccurrences(of: "\"", with: "").split(separator: "\'")
                if let feet = Int(feetInches[safe: 0] ?? ""), let inches = Int(feetInches[safe: 1] ?? "")
                {
                    return (feet, inches)
                }
            }
            
            return convertCentimetersToFeetInches(centimeters: Double(Constants.DEFAULT_HEIGHT))
        }
    }
    
    // MARK: - Birthday PickerView
    let minAge = Constants.MIN_AGE
    let maxAge = Constants.MAX_AGE
    let calendar = Calendar.current
    var minDateComponents = DateComponents()
    var maxDateComponents = DateComponents()
    var maxDate = Date()
    var minDate = Date()
    let serverDateFormatter: DateFormatter =
    {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.SERVER_DATE_FORMAT
        return formatter
    }()
    
    let localDateFormatter: DateFormatter =
    {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: Constants.PRESENTATION_DATE_FORMAT, options: 0, locale: NSLocale.current)
        return formatter
    }()
    
    // MARK: - Public interface
    var onModelChanged: (() -> ())?
    
    var name: String?
    {
        get
        {
            return contact?.first_name
        }
        set
        {
            guard let contact = contact,
                  let newName = newValue else { return }
            contact.first_name = newName
            updateContact(contact: contact)
        }
    }
    
    var lastName: String?
    {
        get
        {
            return contact?.last_name
        }
        set
        {
            guard let contact = contact,
                  let newLastName = newValue else { return }
            contact.last_name = newLastName
            updateContact(contact: contact)
        }
    }
    
    var email: String?
    {
        get
        {
            return contact?.email
        }
        set
        {
            guard let contact = contact,
                  let newEmail = newValue else { return }
            contact.email = newEmail
            updateContact(contact: contact)
        }
    }
    
    var gender: Int?
    {
        get
        {
            if let gender = contact?.gender
            {
                if gender.lowercased() == Constants.GENDER_MALE
                {
                    return 0
                }
                else if gender.lowercased() == Constants.GENDER_FEMALE
                {
                    return 1
                }
                else if gender.lowercased() == Constants.GENDER_OTHER
                {
                    return 2
                }
            }
            return nil
        }
        set
        {
            guard let contact = contact,
                  let newGender = newValue else { return }
            if newGender == 0
            {
                contact.gender = Constants.GENDER_MALE
            }
            else if newGender == 1
            {
                contact.gender = Constants.GENDER_FEMALE
            }
            else if newGender == 2
            {
                contact.gender = Constants.GENDER_OTHER
            }
            updateContact(contact: contact)
        }
    }
    
    var height: String?
    {
        get
        {
            if isMetric
            {
                guard let height = contact?.height else { return nil }
                return String(format: "%.0f", height)
            }
            else
            {
                guard let height = contact?.height else { return nil }
                let (feet, inches) = convertCentimetersToFeetInches(centimeters: height)
                return "\(feet)'\(inches)\""
            }
        }
        set
        {
            guard let contact = contact,
                  let newHeightString = newValue else { return }
            if isMetric
            {
                guard let newHeight = Double(newHeightString) else { return }
                contact.height = newHeight
            }
            else
            {
                let feetInches = newHeightString.replacingOccurrences(of: "\"", with: "").split(separator: "\'")
                guard let feet = Int(feetInches[safe: 0] ?? ""), let inches = Int(feetInches[safe: 1] ?? "") else { return }
                let newHeight = convertFeetInchesToCentimeters(feet: feet, inches: inches)
                contact.height = newHeight
            }
            updateContact(contact: contact)
        }
    }
    
    var weight: String?
    {
        get
        {
            if isMetric
            {
                guard let weight = contact?.weight else { return nil }
                return String(format: "%.0f", convertLbsToKg(lbs: weight))
            }
            else
            {
                guard let weight = contact?.weight else { return nil }
                return String(format: "%.0f", weight)
            }
        }
        set
        {
            guard let contact = contact,
                  let newWeightString = newValue,
                  let newWeight = Double(newWeightString) else { return }
            if isMetric
            {
                contact.weight = convertKgToLbs(kg: newWeight)
            }
            else
            {
                contact.weight = newWeight
            }
            updateContact(contact: contact)
        }
    }
    
    var birthDateString: String?
    {
        if let birthDate = contact?.birth_date
        {
            guard let date = serverDateFormatter.date(from: birthDate) else { return nil }
            let dateString = localDateFormatter.string(from: date).replacingOccurrences(of: "-", with: "/")
            return "\(NSLocalizedString("Born", comment: "")) \(dateString)"
        }
        return nil
    }
    
    var birthDate: Date?
    {
        get
        {
            if let birthDate = contact?.birth_date
            {
                return serverDateFormatter.date(from: birthDate)
            }
            return nil
        }
        set
        {
            guard let contact = contact,
                  let newBirthDate = newValue else { return }
            let newBirthDateString = serverDateFormatter.string(from: newBirthDate)
            contact.birth_date = newBirthDateString
            updateContact(contact: contact)
        }
    }
}

// MARK: - Private methods
private extension EditProfileViewModel
{
    func updateContact(contact: Contact)
    {
        ObjectStore.shared.ClientSave(contact)
        onModelChanged?()
    }
    
    func convertCentimetersToFeetInches(centimeters: Double) -> (Int, Int)
    {
        let heightCentimeters = Measurement(value: centimeters, unit: UnitLength.centimeters)
        let heightInches = heightCentimeters.converted(to: UnitLength.inches)
        return splitFeetInches(inches: heightInches.value)
    }
    
    func convertFeetInchesToCentimeters(feet: Int, inches: Int) -> Double
    {
        let feetCentimeters = Measurement(value: Double(feet), unit: UnitLength.feet).converted(to: UnitLength.centimeters).value
        let inchesCentimeters = Measurement(value: Double(inches), unit: UnitLength.inches).converted(to: UnitLength.centimeters).value
        let result = feetCentimeters + inchesCentimeters
        return result
    }
    
    func splitFeetInches(inches: Double) -> (Int, Int)
    {
        let feet = Int(inches / 12)
        let inchesRemainder = Int(inches.truncatingRemainder(dividingBy: 12))
        return (feet, inchesRemainder)
    }
    
    func convertLbsToKg(lbs: Double) -> Double
    {
        return lbs * 0.45359237
    }
    
    func convertKgToLbs(kg: Double) -> Double
    {
        return kg / 0.45359237
    }
}
