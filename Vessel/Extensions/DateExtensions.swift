//
//  DateExtensions.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/9/22.
//

import Foundation

extension Date
{
    //Create a Date from a string like so:
    //Date("2022-07-09")
    init(_ dateString: String)
    {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        let date = dateStringFormatter.date(from: dateString)!
        self.init(timeInterval: 0, since: date)
    }
    
    static func defaultBirthDate() -> Date
    {
        //returns a date based on the average age of a member as defined in Constants
        let calendar = Calendar.current
        let averageAge = Constants.AVERAGE_AGE
        // set the initial year to current year - averageAge
        var dateComponents = calendar.dateComponents([.day, .month, .year], from: Date())
        
        if let year = dateComponents.year
        {
            dateComponents.year = year - averageAge
        }
        if let date = calendar.date(from: dateComponents)
        {
            return date
        }
        //should always return a date above but just in case...
        return Date("2000-07-09") //arbitrary
    }
    
    static func abbreviationFor(month: Int) -> String
    {
        switch month
        {
            case 1:
                return NSLocalizedString("Jan", comment: "abbreviation for January")
            case 2:
                return NSLocalizedString("Feb", comment: "abbreviation for February")
            case 3:
                return NSLocalizedString("Mar", comment: "abbreviation for March")
            case 4:
                return NSLocalizedString("Apr", comment: "abbreviation for April")
            case 5:
                return NSLocalizedString("May", comment: "abbreviation for May")
            case 6:
                return NSLocalizedString("Jun", comment: "abbreviation for June")
            case 7:
                return NSLocalizedString("Jul", comment: "abbreviation for July")
            case 8:
                return NSLocalizedString("Aug", comment: "abbreviation for August")
            case 9:
                return NSLocalizedString("Sept", comment: "abbreviation for September")
            case 10:
                return NSLocalizedString("Oct", comment: "abbreviation for October")
            case 11:
                return NSLocalizedString("Nov", comment: "abbreviation for November")
            case 12:
                return NSLocalizedString("Dec", comment: "abbreviation for December")
            default:
                return ""
        }
    }
}
