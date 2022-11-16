//
//  DateExtensions.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/9/22.
//

import Foundation

extension Date
{
    static var serverDateFormatter: DateFormatter =
    {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.SERVER_DATE_FORMAT
        return formatter
    }()
    
    // [0 to 6] -> (Monday to Sunday)
    var dayOfWeek: Int?
    {
        let myCalendar = Calendar(identifier: .gregorian)
        let day = myCalendar.component(.weekday, from: self)
        return day == 1 ? 6 : day - 2
    }
    
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
    
    //returns month, day and year Int from standard ISO 8601 date/time string
    static func components(for ISO8601String: String) -> (month: Int, day: Int, year: Int)
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let localDate = formatter.date(from: ISO8601String)
        let month = NSCalendar.current.component(.month, from: localDate!)
        let day = NSCalendar.current.component(.day, from: localDate!)
        let year = NSCalendar.current.component(.year, from: localDate!)
        
        return (month, day, year)
    }
    
    static func components(for date: Date) -> (month: Int, day: Int, year: Int)
    {
        var calendar = NSCalendar.current
        calendar.locale = .current
        
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let year = calendar.component(.year, from: date)
        
        return (month, day, year)
    }
    
    //given a vesselTime value (from a last_updated field), this returns a date
    static func from(vesselTime: Int) -> Date?
    {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let vesselDate = formatter.date(from: "2020/01/01 00:00")?.addingTimeInterval(Double(vesselTime))
        /*if let vdate = vesselDate?.convertToLocalTime(fromTimeZone: "UTC")
        {
            print("v_time: \(vesselTime), date:\(vesselDate), local: \(vdate)")
        }*/

        return vesselDate?.convertToLocalTime(fromTimeZone: "UTC")
    }
    
    func convertToLocalTime(fromTimeZone timeZoneAbbreviation: String) -> Date?
    {
        if let timeZone = TimeZone(abbreviation: timeZoneAbbreviation)
        {
            let targetOffset = TimeInterval(timeZone.secondsFromGMT(for: self))
            let localOffeset = TimeInterval(TimeZone.autoupdatingCurrent.secondsFromGMT(for: self))

            return self.addingTimeInterval(localOffeset - targetOffset)
        }
    
        return nil
    }
}
