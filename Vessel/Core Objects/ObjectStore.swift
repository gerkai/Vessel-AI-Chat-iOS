//
//  ObjectStore.swift
//  Vessel
//
//  Created by Carson Whitsett on 3/4/22.
//  Manages storage of all core objects and synchronization with back end
//  Reference ObjectStore flow here: https://www.notion.so/vesselhealth/Object-Store-640d210ea53e42ebbadd7be362ce39b2

import UIKit

enum StorageType: Int
{
    case cache          //cache only
    case disk           //disk only
    case cacheAndDisk   //cache and disk
}

//every object should be encodable and decodable and it must have an id and a last_updated field
protocol CoreObjectProtocol: Codable
{
    var id: Int {get}
    var last_updated: Int {get set}
    var storage: StorageType {get}
}

struct SpecificObjectReq: Codable
{
    var type: String
    var id: Int
    var last_updated: Int
}

struct ObjectReq: Codable
{
    var id: Int
    var last_updated: Int
}

struct AllObjectReq: Codable
{
    var type: String
    var last_updated: Int
}

class ObjectStore: NSObject
{
    static let shared = ObjectStore()
    var cache: [String: [Int: CoreObjectProtocol]] = [:]
    
    private func cacheObject<T: CoreObjectProtocol>(_ object: T)
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
    
    private func objectFromCache<T: CoreObjectProtocol>(of type: T.Type, id: Int) -> T?
    {
        let objectName = String(describing: type)
        if cache[objectName] != nil
        {
            if let object = cache[objectName]?[id] as? T
            {
                return object
            }
        }
        return nil
    }
    
    //MARK: - Public functions
    
    func loadMainContact(onSuccess success: @escaping () -> Void, onFailure failure: @escaping () -> Void)
    {
        let contactID = Contact.MainID
        get(type: Contact.self, id: contactID)
        { contact in
            let con = contact
            self.cacheObject(con)
            success()
        }
        onFailure:
        {
            failure()
        }
    }
    
    /*func loadAllFoods(onSuccess success: @escaping () -> Void, onFailure failure: @escaping () -> Void)
    {
        
    }*/
    
    func get<T: CoreObjectProtocol>(type: T.Type, id: Int, onSuccess success: @escaping (_ object: T) -> Void, onFailure failure: @escaping () -> Void)
    {
        if let object = objectFromCache(of: type, id: id)
        {
            success(object)
        }
        else if let object = Storage.retrieve(id, as: type )
        {
            success(object)
        }
        else
        {
            let name = String(describing: T.self).lowercased()
        
            Server.shared.getObjects(objects: [SpecificObjectReq(type: name, id: id, last_updated: 0)])
            { objectDict in
                if let values = objectDict[name] as? [[String: Any]]
                {
                    do
                    {
                        let json = try JSONSerialization.data(withJSONObject: values.first!)
                        let decoder = JSONDecoder()

                        let object = try decoder.decode(T.self, from: json)
                        success(object)
                    }
                    catch
                    {
                        print(error)
                        failure()
                    }
                }
                else
                {
                    failure()
                }
            }
            onFailure:
            { error in
                print(error)
                failure()
            }
        }
    }
    
    func getAll<T: CoreObjectProtocol>(type: T.Type, onSuccess success: @escaping (_ objects: [T]) -> Void, onFailure failure: @escaping () -> Void)
    {
        /*if let object = objectFromCache(of: type, id: id)
        {
            success(object)
        }
        else if let object = Storage.retrieve(id, as: type )
        {
            success(object)
        }
        else
        {*/
        let name = String(describing: T.self).lowercased()
        
        Server.shared.getAllObjects(objects: AllObjectReq(type: name, last_updated: 0))
        { objectDict in
            if let values = objectDict[name] as? [[String: Any]]
            {
                do
                {
                    let json = try JSONSerialization.data(withJSONObject: values)
                    let decoder = JSONDecoder()
                    
                    let objects = try decoder.decode([T].self, from: json)
                    success(objects)
                }
                catch
                {
                    print(error)
                    failure()
                }
            }
            else
            {
                failure()
            }
        }
        onFailure:
        { error in
            print(error)
            failure()
        }
    }
    
    //Call this to save objects that arrive from the server
    func serverSave<T: CoreObjectProtocol>(_ object: T)
    {
        //This is an object we received from the back end. Save it to the object store and post a notification that
        //this object has been updated.
        
        if object.storage == .cache || object.storage == .cacheAndDisk
        {
            cacheObject(object)
        }
        if object.storage == .disk || object.storage == .cacheAndDisk
        {
            Storage.store(object)
        }
        //print("Sending .newDataFromServer notificaiton with \(String(describing: T.self))")
        NotificationCenter.default.post(name: .newDataFromServer, object: nil, userInfo: ["objectType": String(describing: T.self)])
    }
    
    //Call this to save objects that have been modified by the client
    func ClientSave<T: CoreObjectProtocol>(_ object: T)
    {
        if object.storage == .cache || object.storage == .cacheAndDisk
        {
            cacheObject(object)
        }
        if object.storage == .disk || object.storage == .cacheAndDisk
        {
            Storage.store(object)
        }

        let objectArray = [object]
        let name = String(describing: type(of: object)).lowercased()
        let dict = [name: objectArray]
        
        //note: When saving Contact, server ignores e-mail address. So even if you change it in the contact, it won't stick. There's an alternate API for just changing the e-mail.
        Server.shared.saveObjects(objects: dict)
        {
            print("Saved \(name)")
        }
        onFailure:
        { result in
            UIView.showError(text: "Error", detailText: result)
        }
    }
    
    func getContact(id: Int) -> Contact?
    {
        //get contact from local cache
        let contactName = "\(Contact.self)"
        return cache[contactName]?[id] as? Contact
    }
}
