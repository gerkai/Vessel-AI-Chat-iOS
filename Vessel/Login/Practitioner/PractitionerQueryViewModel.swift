//
//  PractitionerQueryViewModel.swift
//  Vessel
//
//  Created by Carson Whitsett on 2/23/23.
//

import Foundation

class PractitionerQueryViewModel
{
    var experts: [Expert] = []
    var selectedPractitioner: Int?
    
    init()
    {
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("❇️ \(self)")
        }
        getExperts
        {
            print("Got experts")
        }
        onFailure:
        {
            print("failed to get experts")
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
        return experts.count
    }
    
    func expertFor(index: Int) -> Expert
    {
        return experts[index]
    }
    
    func setExpertAssociation()
    {
        if let selectedIndex = selectedPractitioner
        {
            let expert = experts[selectedIndex]
            Contact.PractitionerID = expert.id
            if expert.logo_image_url != nil
            {
                UserDefaults.standard.set(expert.logo_image_url, forKey: Constants.KEY_PRACTITIONER_IMAGE_URL)
            }
            else
            {
                UserDefaults.standard.removeObject(forKey: Constants.KEY_PRACTITIONER_IMAGE_URL)
            }
        }
    }
    
    func getExperts(onSuccess success: @escaping () -> Void, onFailure failure: @escaping () -> Void)
    {
        var objectReqs: [AllObjectReq] = []
        
        let object = Expert.self
        
        let lastUpdated = Storage.newestLastUpdatedFor(type: object)
        let objectReq = AllObjectReq(type: "\(object.self)".lowercased(), last_updated: lastUpdated)
        objectReqs.append(objectReq)
        //print("\(object): last_udpated: \(lastUpdated)")
        
        Server.shared.getAllExperts(onSuccess:
        { experts in
            var experts = experts
            //sort alphabetically by last_name then by first_name
            experts.sort
            {
                let last_name_a = $0.last_name?.lowercased()
                let last_name_b = $1.last_name?.lowercased()
                let first_name_a = $0.first_name?.lowercased()
                let first_name_b = $1.first_name?.lowercased()
                if last_name_a != last_name_b
                {
                    return last_name_a ?? "" < last_name_b ?? ""
                }
                else
                {
                    return first_name_a ?? "" < first_name_b ?? ""
                }
            }
            self.experts = experts
        },
        onFailure:
        { message in
            print("Unable to retrieve experts")
        })
    }
}
