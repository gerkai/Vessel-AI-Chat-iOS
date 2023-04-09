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
    
    var contactFlags: Int
    {
        contact?.flags ?? 0
    }
    
    // MARK: - Birthday PickerView
    let minAge = Constants.MIN_AGE
    let maxAge = Constants.MAX_AGE
    let calendar = Calendar.current
    var minDateComponents = DateComponents()
    var maxDateComponents = DateComponents()
    var maxDate = Date()
    var minDate = Date()
    
    let localDateFormatter: DateFormatter =
    {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: Constants.PRESENTATION_DATE_FORMAT, options: 0, locale: NSLocale.current)
        return formatter
    }()
    
    @Resolved private var analytics: Analytics
    
    // MARK: - Public interface
    var onModelChanged: (() -> ())?
    var onError: ((_ error: String) -> ())?
    
    var name: String?
    {
        get
        {
            return contact?.first_name
        }
        set
        {
            guard let contact = contact,
                  let newName = newValue else
            {
                assertionFailure("EditProfileViewModel-name.setter: mainContact not available")
                return
            }
            guard newName.isValidName() else
            {
                onError?(NSLocalizedString("Please enter a valid first name", comment: ""))
                onModelChanged?()
                return
            }
            
            contact.first_name = newName
            updateContact(contact: contact)
            analytics.setUserProperty(property: "$name", value: contact.fullName)
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
                  let newLastName = newValue else
            {
                assertionFailure("EditProfileViewModel-lastName.setter: mainContact not available")
                return
            }
            guard newLastName.isValidName() else
            {
                onError?(NSLocalizedString("Please enter a valid last name", comment: ""))
                onModelChanged?()
                return
            }
            contact.last_name = newLastName
            updateContact(contact: contact)
            analytics.setUserProperty(property: "$name", value: contact.fullName)
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
                  let newEmail = newValue else
            {
                assertionFailure("EditProfileViewModel-email.setter: mainContact not available")
                return
            }
            contact.email = newEmail
            updateContact(contact: contact)
        }
    }
    
    var gender: Int?
    {
        get
        {
            if let genderString = contact?.gender,
               let gender = Gender(genderString: genderString)
            {
                return gender.rawValue
            }
            return nil
        }
        set
        {
            guard let contact = contact,
                  let newGender = newValue,
                  let gender = Gender(rawValue: newGender) else
            {
                assertionFailure("EditProfileViewModel-gender.setter: mainContact not available or gender not parseable")
                return
            }
            switch gender
            {
            case .male:
                contact.gender = Constants.GENDER_MALE
            case .female:
                contact.gender = Constants.GENDER_FEMALE
            case .other:
                contact.gender = Constants.GENDER_OTHER
            }
            updateContact(contact: contact)
            guard let gender = contact.gender else
            {
                assertionFailure("EditProfileViewModel-gender.setter: mainContact's gender not available")
                return
            }
            analytics.setUserProperty(property: "Gender", value: gender)
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
                  let newHeightString = newValue else
            {
                assertionFailure("EditProfileViewModel-height.setter: mainContact not available")
                return
            }
            if isMetric
            {
                guard let newHeight = Double(newHeightString) else
                {
                    assertionFailure("EditProfileViewModel-height.setter: newHeightString not parseable to Double")
                    return
                }
                contact.height = max(min(newHeight, Double(Constants.MAX_HEIGHT_METRIC)), Double(Constants.MIN_HEIGHT_METRIC))
            }
            else
            {
                let feetInches = newHeightString.replacingOccurrences(of: "\"", with: "").split(separator: "\'")
                guard let feet = Int(feetInches[safe: 0] ?? ""), let inches = Int(feetInches[safe: 1] ?? "") else
                {
                    assertionFailure("EditProfileViewModel-height.setter: feet and inches not parseable")
                    return
                }
                let newHeight = convertFeetInchesToCentimeters(feet: feet, inches: inches)
                contact.height = newHeight
            }
            updateContact(contact: contact)
            guard let height = contact.height else
            {
                assertionFailure("EditProfileViewModel-height.setter: mainContact's height not available")
                return
            }
            analytics.setUserProperty(property: "Height", value: height)
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
                  let newWeight = Double(newWeightString) else
            {
                assertionFailure("EditProfileViewModel-weight.setter: mainContact not available or newWeightString not parseable to Double")
                return
            }
            if isMetric
            {
                contact.weight = max(min(convertKgToLbs(kg: newWeight), Constants.MAX_WEIGHT_IMPERIAL), Constants.MIN_WEIGHT_IMPERIAL)
            }
            else
            {
                contact.weight = max(min(newWeight, Constants.MAX_WEIGHT_IMPERIAL), Constants.MIN_WEIGHT_IMPERIAL)
            }
            updateContact(contact: contact)
            guard let weight = contact.weight else
            {
                assertionFailure("EditProfileViewModel-weight.setter: mainContact's weight not available")
                return
            }
            analytics.setUserProperty(property: "Weight", value: weight)
        }
    }
    
    var birthDateString: String?
    {
        if let birthDate = contact?.birth_date
        {
            guard let date = Date.serverDateFormatter.date(from: birthDate) else { return nil }
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
                return Date.serverDateFormatter.date(from: birthDate)
            }
            return nil
        }
        set
        {
            guard let contact = contact,
                  let newBirthDate = newValue else
            {
                assertionFailure("EditProfileViewModel-birthDate.setter: mainContact not available")
                return
            }
            contact.flags &= ~Constants.DECLINED_BIRTH_DATE
            let newBirthDateString = Date.serverDateFormatter.string(from: newBirthDate)
            contact.birth_date = newBirthDateString
            updateContact(contact: contact)
            analytics.setUserProperty(property: "DOB", value: newBirthDateString)
        }
    }
    
    func getMinHeightImperial() -> (Int, Int)
    {
        return convertCentimetersToFeetInches(centimeters: Double(Constants.MIN_HEIGHT_METRIC))
    }
    
    func getMaxHeightImperial() -> (Int, Int)
    {
        return convertCentimetersToFeetInches(centimeters: Double(Constants.MAX_HEIGHT_METRIC))
    }
}

// MARK: - Private methods
private extension EditProfileViewModel
{
    func updateContact(contact: Contact)
    {
        ObjectStore.shared.clientSave(contact)
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
