//
//  PractitionerQueryViewModel.swift
//  Vessel
//
//  Created by Carson Whitsett on 2/23/23.
//

import Foundation

protocol PractitionerQueryViewModelDelegate: AnyObject
{
    func expertsLoaded()
}

class PractitionerQueryViewModel
{
    var experts: [Expert] = []
    var filteredExperts: [Expert] = []
    var selectedPractitioner: Int?
    var delegate: PractitionerQueryViewModelDelegate?
    
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
        return filteredExperts.count
    }
    
    func expertFor(index: Int) -> Expert
    {
        return filteredExperts[index]
    }
    
    func expertFilter(filterString: String)
    {
        if filterString.count == 0
        {
            filteredExperts = experts
        }
        else
        {
            filteredExperts = []
            let lowerCasedFilterString = filterString.lowercased()
            for item in experts
            {
                if (item.first_name?.lowercased().range(of: lowerCasedFilterString) != nil) || (item.last_name?.lowercased().range(of: lowerCasedFilterString) != nil) || (item.business_name?.lowercased().range(of: lowerCasedFilterString) != nil)
                {
                    filteredExperts.append(item)
                }
            }
        }
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
                let businessNameA = $0.business_name?.lowercased() ?? ""
                let businessNameB = $1.business_name?.lowercased() ?? ""
                let lastNameA = $0.last_name?.lowercased() ?? ""
                let lastNameB = $1.last_name?.lowercased() ?? ""
                let firstNameA = $0.first_name?.lowercased() ?? ""
                let firstNameB = $1.first_name?.lowercased() ?? ""
                if businessNameA.isEmpty && !businessNameB.isEmpty
                {
                    return false
                }
                else if !businessNameA.isEmpty && businessNameB.isEmpty
                {
                    return true
                }
                else if !businessNameA.isEmpty && !businessNameB.isEmpty && businessNameA != businessNameB
                {
                    return businessNameA < businessNameB
                }
                else if lastNameA != lastNameB
                {
                    return lastNameA < lastNameB
                }
                else
                {
                    return firstNameA < firstNameB
                }
            }
            self.experts = experts
            self.filteredExperts = experts
            self.delegate?.expertsLoaded()
        },
        onFailure:
        { message in
            print("Unable to retrieve experts")
        })
    }
    
    func loadStaff(onCompletion: @escaping (_ staff: [Staff]) -> Void, onFailure: @escaping () -> Void)
    {
        guard let expertId = Contact.PractitionerID else
        {
            DispatchQueue.main.async
            {
                onFailure()
            }
            return
        }
        Server.shared.getStaff(expertId: expertId) { staff in
            DispatchQueue.main.async
            {
                onCompletion(staff)
            }
        } onFailure: { message in
            DispatchQueue.main.async
            {
                onFailure()
            }
        }
    }
}
