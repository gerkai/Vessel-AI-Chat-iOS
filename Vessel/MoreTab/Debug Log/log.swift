//
//  log.swift
//
//  Created by Carson Whitsett on 8/13/21.
//

import Foundation

let EVENT_LOG_KEY = "debugLog"

extension Notification.Name
{
    static let LOG_UPDATED_NOTIFICATION = Notification.Name("LogUpdatedNotification")
}

extension Date
{
    static func getCurrentDate() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return dateFormatter.string(from: Date())
    }
}

var eventLog: [String] = []

func Log_Init()
{
    eventLog = []
}

func Log_dataFilePath(fileName: String) -> String
{
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    return "\(documentsPath)/\(fileName)"
}

func Log_Load()
{
    let defaults = UserDefaults.standard
    eventLog = defaults.stringArray(forKey: EVENT_LOG_KEY) ?? [String]()
}

func Log_Save()
{
    let defaults = UserDefaults.standard
    defaults.set(eventLog, forKey: EVENT_LOG_KEY)
    defaults.synchronize()
}

func Log_Clear()
{
    eventLog = []
    Log_Save()
    Log_Refresh()
}

//set shouldPrint to false if you don't want this to also print to the console
func Log_Add(_ text: String, _ shouldPrint: Bool = true)
{
    let timeStamp = Date.getCurrentDate()
    
    if shouldPrint
    {
        print("\(timeStamp) \(text)")
    }
    eventLog.append("\(timeStamp) \(text)\n")
    Log_Refresh()
}

func Log_Get() -> String
{
    var string = "\n\n\n\n\nDebug Log\n\n"
    
    for entry in eventLog
    {
        string.append(entry)
    }
    return string
}

func Log_Refresh()
{
    NotificationCenter.default.post(name: .LOG_UPDATED_NOTIFICATION, object: nil)
}
