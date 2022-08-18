//
//  ObjectStore.swift
//  Vessel
//
//  Created by Carson Whitsett on 3/4/22.
//  Manages storage of all core objects and synchronization with back end

import UIKit

//every object should be encodable and decodable and it must have an id
protocol CoreObjectProtocol: Codable
{
    var id: Int {get}
}

class ObjectStore: NSObject
{
    static let shared = ObjectStore()
    var repo: [String: [Int: CoreObjectProtocol]] = [:]
    
    private func saveObject<T: CoreObjectProtocol>(_ object: T)
    {
        let objectName = String(describing: type(of: object))
        if repo[objectName] != nil
        {
            repo[objectName]![object.id] = object
        }
        else
        {
            //create the collection dictionary and add to repo
            repo[objectName] = [object.id: object]
        }
    }
    
    //MARK: - Public functions
    
    //Call this to save objects that arrive from the server
    func serverSave<T: CoreObjectProtocol>(_ object: T)
    {
        //This is an object we received from the back end. Save it to the object store and post a notification that
        //this object has been updated.
        
        //Storage.store(object)
        saveObject(object)
        //TODO: post notification here
    }
    
    //Call this to save objects that have been modified by the client
    func ClientSave<T: CoreObjectProtocol>(_ object: T)
    {
        //Storage.store(object)
        saveObject(object)
        if String(describing: type(of: object)) == "Contact"
        {
            let objectArray = [object]
            let dict = ["contact": objectArray]
            
            //note: server ignores e-mail address. So even if you change it in the contact, it won't stick. There's an alternate API for just changing the e-mail.
            Server.shared.saveObjects(objects: dict)
            {
                print("Saved Contact")
            }
            onFailure:
            { result in
                UIView.showError(text: "Error", detailText: result)
            }
        }
    }
    
    func getContact(id: Int) -> Contact?
    {
        //get contact from local repo
        let contactName = "\(Contact.self)"
        return repo[contactName]?[id] as? Contact
    }
}
