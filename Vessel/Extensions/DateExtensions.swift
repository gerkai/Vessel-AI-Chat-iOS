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
}
