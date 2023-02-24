//
//  PractitionerQueryViewModel.swift
//  Vessel
//
//  Created by Carson Whitsett on 2/23/23.
//

import Foundation

struct ExpertInfo
{
    let expert_id: Int
    let expert_name: String
    let cobranding_url: String?
}

class PractitionerQueryViewModel
{
    var expertInfo: [ExpertInfo] = [ExpertInfo(expert_id: 1, expert_name: "Shagufta Naseem, MD", cobranding_url: "https://www.dittylabs.com/temp/logo.png"),
        ExpertInfo(expert_id: 2, expert_name: "Hope Atina, MD", cobranding_url: nil),
        ExpertInfo(expert_id: 3, expert_name: "Carson Whitsett, MD", cobranding_url: nil),
        ExpertInfo(expert_id: 4, expert_name: "Jon Carder, MD", cobranding_url: nil),
        ExpertInfo(expert_id: 5, expert_name: "Nico Medina, MD", cobranding_url: nil),
        ExpertInfo(expert_id: 6, expert_name: "Luis Carlos Lozano, MD", cobranding_url: nil),
        ExpertInfo(expert_id: 7, expert_name: "Ben Stein, MD", cobranding_url: nil),
        ExpertInfo(expert_id: 8, expert_name: "Lauren Lehmkuhl, MD", cobranding_url: nil),
        ExpertInfo(expert_id: 9, expert_name: "Sam Angeles, MD", cobranding_url: nil)]
    
    var selectedPractitioner: Int?
    
    init()
    {
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("❇️ \(self)")
        }
    }
    
    deinit
    {
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("❌ \(self)")
        }
    }
    
    func numExperts() -> Int
    {
        return expertInfo.count
    }
    
    func expertFor(index: Int) -> ExpertInfo
    {
        return expertInfo[index]
    }
    
    func setExpertAssociation()
    {
        if let selectedIndex = selectedPractitioner
        {
            let info = expertInfo[selectedIndex]
            Contact.PractitionerID = info.expert_id
            if info.cobranding_url != nil
            {
                UserDefaults.standard.set(info.cobranding_url, forKey: Constants.KEY_PRACTITIONER_IMAGE_URL)
            }
            else
            {
                UserDefaults.standard.removeObject(forKey: Constants.KEY_PRACTITIONER_IMAGE_URL)
            }
        }
    }
}
