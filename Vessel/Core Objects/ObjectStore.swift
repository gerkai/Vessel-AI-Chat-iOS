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

func ServerSave<T: CoreObjectProtocol>(_ object: T)
{
    //This is an object we received from the back end. Save it to the object store and post a notification that
    //this object has been updated.
    Storage.store(object)
    
    //TODO: post notification here
}

func ClientSave<T: CoreObjectProtocol>(_ object: T)
{
    Storage.store(object)
    if String(describing: type(of:object)) == "Contact"
    {
        Server.shared.updateContact(contact: object as! Contact)
        {
            //Navigate to next screen in onboard
        }
        onFailure:
        { result in
            UIView.showError(text: "Error", detailText: result)
        }
    }
}
