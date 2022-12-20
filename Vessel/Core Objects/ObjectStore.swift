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
    var id: Int { get }
    var last_updated: Int { get set }
    var storage: StorageType { get }
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
    
    func clearCache()
    {
        cache = [:]
    }
    
    func removeFromCache<T: CoreObjectProtocol>(_ object: T)
    {
        let objectName = String(describing: type(of: object))
        cache[objectName]?.removeValue(forKey: object.id)
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
    
    func getMetaType(typeString: String) -> CoreObjectProtocol.Type?
    {
        let objectType = typeString.capitalized
        
        if objectType == "\(Result.self)" { return Result.self }
        else if objectType == "\(Food.self)" { return Food.self }
        else if objectType == "\(Plan.self)" { return ServerPlan.self }
        else if objectType == "\(Curriculum.self)" { return Curriculum.self }
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
    
    func testFetch()
    {
        getMostRecent(objectTypes: [Result.self, Food.self], onSuccess: {}, onFailure: {})
    }
    
    func getMostRecent(objectTypes: [CoreObjectProtocol.Type], onSuccess success: @escaping () -> Void, onFailure failure: @escaping () -> Void)
    {
        var objectReqs: [AllObjectReq] = []
        
        for object in objectTypes
        {
            let lastUpdated = Storage.newestLastUpdatedFor(type: object)
            let objectReq = AllObjectReq(type: "\(object.self)".lowercased(), last_updated: lastUpdated)
            objectReqs.append(objectReq)
            //print("\(object): last_udpated: \(lastUpdated)")
        }
        
        Server.shared.getAllObjects(objects: objectReqs)
        { objectDict in
            for typeName in objectDict.keys
            {
                if let metaType = self.getMetaType(typeString: typeName)
                {
                    if let objects = objectDict[typeName] as? [[String: Any]]
                    {
                        for singleObjectDict in objects
                        {
                            do
                            {
                                let json = try JSONSerialization.data(withJSONObject: singleObjectDict)
                                let decoder = JSONDecoder()
                                
                                let object = try decoder.decode(metaType, from: json)
                                //print("Received: \(object.self) with last_updated \(object.last_updated)")
                                self.serverSave(object, notifyNewDataArrived: singleObjectDict["id"] as? Int == objects.last?["id"] as? Int && singleObjectDict["last_updated"] as? Int == objects.last?["last_updated"] as? Int)
                            }
                            catch
                            {
                                print(error)
                            }
                        }
                        //print("\(objects)")
                    }
                }
            }
            success()
            //print("Got objects: \(objectDict)")
            //print(".")
        }
    onFailure:
        { error in
            print("Got error: \(error)")
            print(".")
        }
    }

    //if we know the object is in local storage, this will retrieve it. If it happens to not be in local storage
    //nil will be returned
    func quickGet<T: CoreObjectProtocol>(type: T.Type, id: Int) -> T?
    {
        if let object = objectFromCache(of: type, id: id)
        {
            return object
        }
        else if let object = Storage.retrieve(id, as: type )
        {
            return object
        }
        return nil
    }
    
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
    
    func get<T: CoreObjectProtocol>(type: T.Type, ids: [Int], onSuccess success: @escaping (_ objects: [T]) -> Void, onFailure failure: @escaping () -> Void)
    {
        //See which objects are in cache or storage and build SpecificObjectReq with last_updated populated
        var objectRequests: [SpecificObjectReq] = []
        var objects: [T] = []
        
        let name = String(describing: T.self).lowercased()
        for id in ids
        {
            if let object = objectFromCache(of: type, id: id)
            {
                objectRequests.append(SpecificObjectReq(type: name, id: id, last_updated: object.last_updated))
                objects.append(object)
            }
            else if let object = Storage.retrieve(id, as: type )
            {
                objectRequests.append(SpecificObjectReq(type: name, id: id, last_updated: object.last_updated))
                objects.append(object)
            }
            else
            {
                //if not locally stored, set last_updated to 0 to force a load from the back end
                objectRequests.append(SpecificObjectReq(type: name, id: id, last_updated: 0))
            }
        }
        
        //let caller know immediately of any locally retrieved objects
        //success(objects)
        
        if objectRequests.count == 0
        {
            success(objects)
        }
        else
        {
            Server.shared.getObjects(objects: objectRequests)
            { objectDict in
                if let values = objectDict[name] as? [[String: Any]]
                {
                    do
                    {
                        for value in values
                        {
                            let json = try JSONSerialization.data(withJSONObject: value)
                            let decoder = JSONDecoder()
                            
                            let object = try decoder.decode(T.self, from: json)
                            
                            //save object locally so it will load faster next time
                            self.serverSave(object) //this will send a newDataArrived notification
                            objects.append(object)
                        }
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
                    success(objects)
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
    func serverSave<T: CoreObjectProtocol>(_ object: T, notifyNewDataArrived: Bool = true)
    {
        //This is an object we received from the back end. Save it to the object store and post a notification that
        //this object has been updated.
        
        if object.storage == .cache || object.storage == .cacheAndDisk
        {
            cacheObject(object)
        }
        if object.storage == .disk || object.storage == .cacheAndDisk
        {
            //TEMPORARY if object is ServerPlan
            if let serverPlan = object as? ServerPlan
            {
                Storage.store(ServerPlan.convert(serverPlan: serverPlan))
            }
            else //end temporary code
            {
                Storage.store(object)
            }
        }
        //print("Sending .newDataArrived notification with \(String(describing: T.self))")
        if notifyNewDataArrived
        {
            Log_Add("ObjectStore: serverSave() - post .newDataArrived: \(String(describing: T.self))")
            NotificationCenter.default.post(name: .newDataArrived, object: nil, userInfo: ["objectType": String(describing: T.self)])
        }
    }
    
    //Call this to save a single object that has been modified by the client
    func ClientSave<T: CoreObjectProtocol>(_ object: T)
    {
        var newObject = object
        if let contact = newObject as? Contact
        {
            newObject = contact.replaceEmptyDietsAndAllergies() as! T
        }
        
        if object.storage == .cache || object.storage == .cacheAndDisk
        {
            cacheObject(newObject)
        }
        if object.storage == .disk || object.storage == .cacheAndDisk
        {
            Storage.store(newObject)
        }

        if let plan = newObject as? Plan
        {
            let objectArray = [ServerPlan.convert(plan: plan)]
            let dict = ["plan": objectArray]
            
            //note: When saving Contact, server ignores e-mail address. So even if you change it in the contact, it won't stick. There's an alternate API for just changing the e-mail.
            Server.shared.saveObjects(objects: dict)
            {
                print("Saved \("plan")")
            }
            onFailure:
            { result in
                UIView.showError(text: "Error", detailText: result)
            }
        }
        else
        {
            let objectArray = [newObject]
            
            let name = String(describing: type(of: newObject)).lowercased()
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
    }
    
    //Call this to save multiple objects that has been modified by the client
    func ClientSave<T: CoreObjectProtocol>(_ objects: [T])
    {
        if objects.count != 0
        {
            for object in objects
            {
                if object.storage == .cache || object.storage == .cacheAndDisk
                {
                    cacheObject(object)
                }
                if object.storage == .disk || object.storage == .cacheAndDisk
                {
                    Storage.store(object)
                }
            }
            
            let name = String(describing: type(of: objects.first!)).lowercased()
            let dict = [name: objects]
            
            Server.shared.saveObjects(objects: dict)
            {
                print("Saved \(name)")
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
