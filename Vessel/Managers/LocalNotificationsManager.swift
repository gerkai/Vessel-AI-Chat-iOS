import UIKit
import Pushwoosh

class LocalNotificationsManager: NSObject
{
    static let shared: LocalNotificationsManager =
    {
        let manager = LocalNotificationsManager()
        UNUserNotificationCenter.current().delegate = manager
        Pushwoosh.sharedInstance().notificationCenterDelegateProxy?.add(manager)
        
        Server.shared.getFuel()
        { fuel in
            manager.hasFuel = fuel.is_active || UserDefaults.standard.bool(forKey: Constants.KEY_ENABLE_FUEL)
            manager.hasAMFormula = fuel.hasAMFormula()
            manager.hasPMFormula = fuel.hasPMFormula()
        }
        onFailure:
        { error in
            print("ERROR: \(String(describing: error))")
        }
        
        return manager
    }()
    
    let results = Storage.retrieve(as: Result.self)
    let currentCalendar = Calendar.current
    var hasFuel = false
    var hasAMFormula = false
    var hasPMFormula = false
    
    func setupLocalNotifications()
    {
        setupRemindersNotificationsIfNeeded()
    }
    
    func setupRemindersNotificationsIfNeeded()
    {
//        guard RemoteConfigManager.shared.getValue(for: .remindersFeature) as? Bool ?? false else { return }
            let center = UNUserNotificationCenter.current()

        for reminder in RemindersManager.shared.reminders
        {
//            guard let plan = PlansManager.shared.plans.first(where: { $0.id == reminder.planId }) else
//            {
//                continue
//            }
            
            let content = UNMutableNotificationContent()
            content.title = NSLocalizedString("Remember your plan", comment: "")
            
            var message: String = ""
//            if plan.type == .food
//            {
//                let food = Contact.main()?.suggestedFood.first(where: { $0.id == plan.typeId })
//                let title = food?.title ?? ""
//                message = String(format: NSLocalizedString("Remember to eat %i %@ today", comment: ""), reminder.quantity, reminder.quantity > 1 ? title + "s" : title)
//            }
//            else if plan.type == .activity
//            {
                let activity = PlansManager.shared.activities.first(where: {  $0.id == reminder.planId })
                let title = activity?.title ?? ""
                message = String(format: NSLocalizedString("Remember to do %@ %i times today", comment: ""), title, reminder.quantity)
//            }
//            else if plan.type == .reagentLifestyleRecommendation
//            {
//                let lifestyleRecommendation = PlansManager.shared.activities.first(where: {  $0.id == plan.typeId && $0.isLifestyleRecommendation })
//                let title = lifestyleRecommendation?.title ?? ""
//                message = String(format: NSLocalizedString("Remember to %@ today", comment: ""), title)
//            }
            
            content.body = message
            
            let timeOfDay = RemindersManager.shared.getTimeOfDay(from: reminder.timeOfDay)
            let hour = timeOfDay.hour
            let minute = timeOfDay.minute
            
            for day in reminder.dayOfWeek
            {
                var adjustedDay = day + 2
                if adjustedDay > 7
                {
                    adjustedDay = 1
                }
                let dateComponents = DateComponents(hour: hour, minute: minute, weekday: adjustedDay)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                
                let identifier = "\(reminder.id)+\(day)"
                center.getPendingNotificationRequests { (requests) in
                    let existingRequests = requests.filter({ $0.identifier == identifier })
                    if existingRequests.isEmpty
                    {
                        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                        center.add(request) { (error) in
                            if let error = error
                            {
                                Log_Add("Error scheduling notification: \(error.localizedDescription)")
                            }
                        }
                    }
                }
            }
        }
    }
    
    func createTakeATestReminderIfNeeded()
    {
        guard RemoteConfigManager.shared.getValue(for: .pushNotificationsFeature) as? Bool ?? false else { return }
        guard !RemindersManager.shared.reminders.contains(where: { $0.planId == Constants.TAKE_A_TEST_LIFESTYLE_RECOMMENDATION_ID }) && hasFuel else
        {
            if results.count == 1
            {
                setupWellnessGuidanceReminders()
            }
            return
        }

        // This should be triggered from the backend
        if results.count == 0
        {
            setupFirstTakeATestReminder()
        }
        else if results.count == 1
        {
            setupTakeATestReminder(number: 1)
            setupWellnessGuidanceReminders()
        }
        else if results.count == 2
        {
            setupTakeATestReminder(number: 2)
        }
        else if results.count == 3
        {
            setupTakeATestReminder(number: 3)
        }
        else
        {
            setupRecurringTakeATestReminder()
        }
    }
    
    let titles = [
        NSLocalizedString("Second Test Time!", comment: "Second take a test reminder title"),
        NSLocalizedString("Third Test Today!", comment: "Third take a test reminder title"),
        NSLocalizedString("Time for Your Fourth Test!", comment: "Fourth take a test reminder title")
    ]
    
    let bodies = [
        NSLocalizedString("Good morning! Time for your second Vessel test. Let’s see if your score improved!", comment: "Second take a test reminder"),
        NSLocalizedString("Good morning! Time for your third Vessel test. Your health coach is here to help!", comment: "Third take a test reminder"),
        NSLocalizedString("Good morning! Wellness is a journey. Take your fourth Vessel test and keep progressing. Remember, wellness is a lifelong journey, so don’t be hard on yourself if you slip up. Take it one day at a time, and Vessel is here to support you.", comment: "Fourth take a test reminder")
    ]
    
    let identifiers = [
        "TAKE_A_TEST_SECOND_NOTIFICATION",
        "TAKE_A_TEST_THIRD_NOTIFICATION",
        "TAKE_A_TEST_FOURTH_NOTIFICATION"
    ]
    
    private func setupFirstTakeATestReminder()
    {
        guard !RemindersManager.shared.reminders.contains(where: { $0.planId == Constants.TAKE_A_TEST_LIFESTYLE_RECOMMENDATION_ID }) else { return }

        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = "\(NSLocalizedString("Time for Your First Test!", comment: "First take a test reminder title"))"
        content.body = NSLocalizedString("Good morning! Discover what your body needs with your first Vessel test today.", comment: "First take a test reminder")
        content.userInfo = ["destination": RoutingOption.takeATest.rawValue]
        
        let hour = 7
        let minute = 30
        var dateComponents = DateComponents()

        if !UserDefaults.standard.bool(forKey: Constants.KEY_USE_SHORT_PERIODS_FOR_TAKE_A_TEST_PUSHES)
        {
            dateComponents.day = 1
        }
        
        guard let nextDate = currentCalendar.date(byAdding: dateComponents, to: Date()) else { return }
        var nextDateComponents = currentCalendar.dateComponents([.year, .month, .day], from: nextDate)
        nextDateComponents.hour = hour
        if UserDefaults.standard.bool(forKey: Constants.KEY_USE_SHORT_PERIODS_FOR_TAKE_A_TEST_PUSHES)
        {
            nextDateComponents.minute = minute + 1
        }
        else
        {
            nextDateComponents.minute = minute
        }
        let trigger = UNCalendarNotificationTrigger(dateMatching: nextDateComponents, repeats: false)
        
        let identifier = "TAKE_A_TEST_FIRST_NOTIFICATION"
        center.getPendingNotificationRequests { (requests) in
            let existingRequests = requests.filter({ $0.identifier == identifier })
            if existingRequests.isEmpty
            {
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                center.add(request) { (error) in
                    if let error = error
                    {
                        print("Error scheduling notification: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func setupTakeATestReminder(number: Int)
    {
        guard number != 0 else
        {
            setupFirstTakeATestReminder()
            return
        }
        
        guard !RemindersManager.shared.reminders.contains(where: { $0.planId == Constants.TAKE_A_TEST_LIFESTYLE_RECOMMENDATION_ID }) else { return }

        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = titles[number - 1]
        content.body = bodies[number - 1]
        content.userInfo = ["destination": RoutingOption.takeATest.rawValue]

        var dateComponents = DateComponents()
        if UserDefaults.standard.bool(forKey: Constants.KEY_USE_SHORT_PERIODS_FOR_TAKE_A_TEST_PUSHES)
        {
            dateComponents.minute = 1
        }
        else
        {
            dateComponents.day = 7
        }
        
        guard let nextDate = currentCalendar.date(byAdding: dateComponents, to: Date()) else { return }
        let nextDateComponents = currentCalendar.dateComponents([.year, .month, .day, .hour, .minute], from: nextDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: nextDateComponents, repeats: false)
        
        let identifier = identifiers[number - 1]
        center.getPendingNotificationRequests { (requests) in
            let existingRequests = requests.filter({ $0.identifier == identifier })
            if existingRequests.isEmpty
            {
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                center.add(request) { (error) in
                    if let error = error
                    {
                        print("Error scheduling notification: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func setupRecurringTakeATestReminder()
    {
        guard !RemindersManager.shared.reminders.contains(where: { $0.planId == Constants.TAKE_A_TEST_LIFESTYLE_RECOMMENDATION_ID }) else { return }

        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = "\(NSLocalizedString("Monthly Test Reminder", comment: ""))"
        content.body = NSLocalizedString("Good morning! Time for your Vessel test. Need help? Your coach is just a message away!", comment: "Fifth take a test reminder")
        content.userInfo = ["destination": RoutingOption.takeATest.rawValue]
        
        var dateComponents = DateComponents()
        if UserDefaults.standard.bool(forKey: Constants.KEY_USE_SHORT_PERIODS_FOR_TAKE_A_TEST_PUSHES)
        {
            dateComponents.minute = 1
        }
        else
        {
            dateComponents.month = 1
        }
        
        guard let nextDate = currentCalendar.date(byAdding: dateComponents, to: Date()) else { return }
        let nextDateComponents = currentCalendar.dateComponents([.year, .month, .day, .hour, .minute], from: nextDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: nextDateComponents, repeats: true)
        
        let identifier = "TAKE_A_TEST_RECURRING_NOTIFICATION"
        center.getPendingNotificationRequests { (requests) in
            let existingRequests = requests.filter({ $0.identifier == identifier })
            if existingRequests.isEmpty
            {
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                center.add(request) { (error) in
                    if let error = error
                    {
                        print("Error scheduling notification: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func setupWellnessGuidanceReminders()
    {
        let center = UNUserNotificationCenter.current()
        
        let titles = [
            NSLocalizedString("Welcome to Week 1!", comment: "First wellness guidance reminder title"),
            NSLocalizedString("Unlimited Coach Access", comment: "Second wellness guidance reminder title"),
            NSLocalizedString("Stay Encouraged in Week 3!", comment: "Third wellness guidance reminder title"),
            NSLocalizedString("Welcome to Week 4!", comment: "Fourth wellness guidance reminder title")]
        
        let texts = [
            NSLocalizedString("Welcome to the first week of your Vessel wellness program. Your daily insights are personalized to you, and just 3 minutes a day will help you reach your goals. Check out today's insight now.", comment: "First wellness guidance reminder"),
            NSLocalizedString("Welcome to week two! Did you know you get unlimited messaging with Vessel-certified nutritionists included with your membership? Check it out.", comment: "Second wellness guidance reminder"),
            NSLocalizedString("Welcome to week three! If you’ve been sticking to your daily plan, you should start to see hydration and nutrient levels improve. If not, don’t get discouraged. Ask your coach for guidance and you’ll get there, pinky swear!", comment: "Third wellness guidance reminder"),
            NSLocalizedString("Welcome to week four! This is the last week of weekly testing. We recommend testing once a month from here and following your daily plan to maintain healthy levels and build good habits.", comment: "Fourth wellness guidance reminder")]
        let days = [1, 8, 15, 22]

        for (index, text) in texts.enumerated()
        {
            let content = UNMutableNotificationContent()
            content.title = titles[index]
            content.body = text
            switch index
            {
            case 0:
                content.userInfo = ["destination": RoutingOption.todayTab.rawValue]
            case 1, 2:
                content.userInfo = ["destination": RoutingOption.coachTab.rawValue]
            case 3:
                break
            default:
                break
            }
            
            var dateComponents = DateComponents()
            if UserDefaults.standard.bool(forKey: Constants.KEY_USE_SHORT_PERIODS_FOR_GENERAL_WELLNESS_PUSHES)
            {
                dateComponents.day = days[index]
            }
            else
            {
                dateComponents.minute = days[index]
            }
            
            guard let nextDate = currentCalendar.date(byAdding: dateComponents, to: Date()) else { return }
            let nextDateComponents = currentCalendar.dateComponents([.year, .month, .day, .hour, .minute], from: nextDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: nextDateComponents, repeats: false)
            
            let identifier = "GENERAL_WELLNESS: \(index)"
            center.getPendingNotificationRequests { (requests) in
                let existingRequests = requests.filter({ $0.identifier == identifier })
                if existingRequests.isEmpty
                {
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                    center.add(request) { (error) in
                        if let error = error
                        {
                            print("Error scheduling notification: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
    
    func setupFuelReminders()
    {
        guard RemoteConfigManager.shared.getValue(for: .pushNotificationsFeature) as? Bool ?? false else { return }
        let center = UNUserNotificationCenter.current()
        
        let titles = [
            NSLocalizedString("Feel the Power of B Vitamins", comment: "First fuel reminder title"),
            NSLocalizedString("Fuel Supplements: Made for You", comment: "Second fuel reminder title"),
            NSLocalizedString("Healthy Habits Formed!", comment: "Third fuel reminder title"),
            NSLocalizedString("Boost Your Longevity", comment: "Fourth fuel reminder title"),
            NSLocalizedString("Modify Fuel for New Issues", comment: "Fifth fuel reminder title")
        ]
        
        let texts = [
            NSLocalizedString("Some supplements, like B vitamins, give instant energy. Stick with it to feel the benefits!", comment: "First fuel reminder"),
            NSLocalizedString("Your Fuel supplements are tailored to your needs and backed by research.", comment: "Second fuel reminder"),
            NSLocalizedString("You've likely formed a healthy habit if you've been taking Fuel regularly. Great job!", comment: "Third fuel reminder"),
            NSLocalizedString("Maintain optimal nutrient levels with Fuel supplements for better health & longevity.", comment: "Fourth fuel reminder"),
            NSLocalizedString("Address health concerns by modifying your Fuel formula. Reach out to your coach!", comment: "Fifth fuel reminder")
        ]
        let days = [7, 14, 21, 28, 35]
        
        for (index, text) in texts.enumerated()
        {
            let content = UNMutableNotificationContent()
            content.title = titles[index]
            content.body = text
            
            if hasAMFormula
            {
                let hour = 12
                let minute = 30
                
                var dateComponents = DateComponents()
                if UserDefaults.standard.bool(forKey: Constants.KEY_USE_SHORT_PERIODS_FOR_FUEL_PUSHES)
                {
                    dateComponents.minute = days[index]
                }
                else
                {
                    dateComponents.day = days[index]
                }
                
                guard let nextDate = currentCalendar.date(byAdding: dateComponents, to: Date()) else { return }
                var nextDateComponents = currentCalendar.dateComponents([.year, .month, .day, .hour, .minute], from: nextDate)
                nextDateComponents.hour = hour
                if !UserDefaults.standard.bool(forKey: Constants.KEY_USE_SHORT_PERIODS_FOR_FUEL_PUSHES)
                {
                    nextDateComponents.minute = minute
                }
                let trigger = UNCalendarNotificationTrigger(dateMatching: nextDateComponents, repeats: false)
                
                let identifier = "FUEL AM: \(index)"
                center.getPendingNotificationRequests { (requests) in
                    let existingRequests = requests.filter({ $0.identifier == identifier })
                    if existingRequests.isEmpty
                    {
                        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                        center.add(request) { (error) in
                            if let error = error
                            {
                                print("Error scheduling notification: \(error.localizedDescription)")
                            }
                        }
                    }
                }
            }
            
            if hasPMFormula
            {
                 let hour = 19
                 let minute = 30
                 
                 var dateComponents = DateComponents()
                 if UserDefaults.standard.bool(forKey: Constants.KEY_USE_SHORT_PERIODS_FOR_FUEL_PUSHES)
                 {
                     dateComponents.minute = days[index]
                 }
                 else
                 {
                     dateComponents.day = days[index]
                 }
                 
                 guard let nextDate = currentCalendar.date(byAdding: dateComponents, to: Date()) else { return }
                 var nextDateComponents = currentCalendar.dateComponents([.year, .month, .day, .hour, .minute], from: nextDate)
                 nextDateComponents.hour = hour
                 if !UserDefaults.standard.bool(forKey: Constants.KEY_USE_SHORT_PERIODS_FOR_FUEL_PUSHES)
                 {
                     nextDateComponents.minute = minute
                 }
                 let trigger = UNCalendarNotificationTrigger(dateMatching: nextDateComponents, repeats: false)
                 
                 let identifier = "FUEL PM: \(index)"
                 center.getPendingNotificationRequests { (requests) in
                     let existingRequests = requests.filter({ $0.identifier == identifier })
                     if existingRequests.isEmpty
                     {
                         let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                         center.add(request) { (error) in
                             if let error = error
                             {
                                 print("Error scheduling notification: \(error.localizedDescription)")
                             }
                         }
                     }
                 }
            }
            else
            {
                // Doesn't have fuel, returning
                return
            }
        }
    }
}

extension LocalNotificationsManager: UNUserNotificationCenterDelegate
{
    // Used when app is in foreground when the notification arrives
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        // Show notification even if the app is open
        completionHandler([.banner, .list, .sound])
    }

    // The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from application:didFinishLaunchingWithOptions:.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        if let destination = RoutingOption(rawValue: response.notification.request.content.userInfo["destination"] as? String ?? "")
        {
            _ = RouteManager.shared.routeTo(destination)
        }
    }
}
