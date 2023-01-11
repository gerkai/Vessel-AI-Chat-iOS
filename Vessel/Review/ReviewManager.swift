//
//  ReviewManager.swift
//  Vessel
//
//  Created by Carson Whitsett on 1/10/23.
//

import UIKit

let DAYS_TO_SHOW_REVIEW_PROMPT = 12

func ReviewManagerStart()
{
    guard let contact = Contact.main() else { return }
    if contact.flags & Constants.HAS_RATED_APP == 0
    {
        let launchDate = UserDefaults.standard.object(forKey: Constants.KEY_FIRST_LAUNCH_DATE) as? Date
        if launchDate == nil
        {
            print("Setting initial launch date to: \(Date())")
            UserDefaults.standard.set(Date(), forKey: Constants.KEY_FIRST_LAUNCH_DATE)
        }
    }
}

func ReviewManagerExperienceReview(presentOverVC: UIViewController)
{
    guard let contact = Contact.main() else { return }
    if contact.flags & Constants.HAS_RATED_APP == 0
    {
        let date = UserDefaults.standard.object(forKey: Constants.KEY_FIRST_LAUNCH_DATE) as? Date
        if date != nil
        {
            if let diffInDays = Calendar.current.dateComponents([.day], from: date!, to: Date()).day
            {
                print("Days since initial launch: \(diffInDays)")
                if diffInDays >= DAYS_TO_SHOW_REVIEW_PROMPT
                {
                    let storyboard = UIStoryboard(name: "Review", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "ReviewViewController") as! ReviewViewController
                    vc.parentVC = presentOverVC
                    presentOverVC.present(vc, animated: false)
                }
            }
        }
    }
}
