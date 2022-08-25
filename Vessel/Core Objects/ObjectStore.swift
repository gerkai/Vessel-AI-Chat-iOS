//
//  ObjectStore.swift
//  Vessel
//
//  Created by Carson Whitsett on 3/4/22.
//  Manages storage of all core objects and synchronization with back end
//  Reference ObjectStore flow here: https://www.notion.so/vesselhealth/Object-Store-640d210ea53e42ebbadd7be362ce39b2

import UIKit

//every object should be encodable and decodable and it must have an id
protocol CoreObjectProtocol: Codable
{
    var id: Int {get}
}

enum ObjectType: String, Codable
{
    case contact
}

struct ObjectReq: Codable
{
    var type: ObjectType
    var id: Int
    var last_updated: Int
}

struct SpecificObjectReq: Codable
{
    var id: Int
    var last_updated: Int
}

class ObjectStore: NSObject
{
    static let shared = ObjectStore()
    var cache: [String: [Int: CoreObjectProtocol]] = [:]
    
    private func saveObject<T: CoreObjectProtocol>(_ object: T)
    {
        let objectName = String(describing: type(of: object))
        if cache[objectName] != nil
        {
            cache[objectName]![object.id] = object
        }
        else
        {
            //create the collection dictionary and add to cache
            cache[objectName] = [object.id: object]
        }
    }
    
    //MARK: - Public functions
    
    func loadMainContact(onSuccess success: @escaping () -> Void, onFailure failure: @escaping () -> Void)
    {
        let contactID = Contact.MainID
        let type = ObjectType.contact
        get(type: type, id: contactID)
        { contact in
            let con = contact as! Contact
            self.saveObject(con)
            success()
        }
        onFailure:
        {
            failure()
        }
    }
    
    func get(type: ObjectType, id: Int, onSuccess success: @escaping (_ object: CoreObjectProtocol) -> Void, onFailure failure: @escaping () -> Void)
    {
        if let object = cache[type.rawValue]?[id]
        {
            success(object)
        }
        else
        {
            Server.shared.getObjects(objects: [ObjectReq(type: type, id: id, last_updated: 0)])
            { objectDict in
                if let values = objectDict[type.rawValue] as? [[String: Any]]
                {
                    do
                    {
                        let json = try JSONSerialization.data(withJSONObject: values.first!)
                        let decoder = JSONDecoder()
                        if type == .contact
                        {
                            let contact = try decoder.decode(Contact.self, from: json)
                            self.saveObject(contact)
                            success(contact)
                        }
                        else
                        {
                            failure()
                        }
                    }
                    catch
                    {
                        print(error)
                        failure()
                    }
                }
            }
            onFailure:
            { error in
                print(error)
                failure()
            }
        }
    }
    
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
        //get contact from local cache
        let contactName = "\(Contact.self)"
        return cache[contactName]?[id] as? Contact
    }
}
