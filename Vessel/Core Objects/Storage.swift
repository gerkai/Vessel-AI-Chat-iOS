//
//  Storage.swift
//  Vessel
//
//  Created by Carson Whitsett on 3/4/22.
//
//  Handles storage and retrieval of core objects to/from disk.
//  Objects can be saved to the documents directory (backed up by iCloud) or the caches directory
//  defaults to caches directory if directory not specified by caller.
//  Path from the caches or documents directory is built as follows:
//      /[userID]/[environment]/[objectType]/objectID
//      [environment] will be either /d, /s, or /p for development, staging or production.
//  A typical path would look like:
//  .../Caches/2441/d/Result/370316

import Foundation

public class Storage
{
    fileprivate init() { }
    
    enum Directory
    {
        // Only documents and other data that is user-generated, or that cannot otherwise be recreated by your application, should be stored in the <Application_Home>/Documents directory and will be automatically backed up by iCloud.
        case documents
        
        // Data that can be downloaded again or regenerated should be stored in the <Application_Home>/Library/Caches directory. Examples of files you should put in the Caches directory include database cache files and downloadable content, such as that used by magazine, newspaper, and map applications.
        case caches
    }
    
    static fileprivate func environmentComponent() -> String
    {
        let index = UserDefaults.standard.integer(forKey: Constants.environmentKey)
        switch index
        {
            case Constants.DEV_INDEX:
                return "d"
            case Constants.STAGING_INDEX:
                return "s"
            default:
                return "p"
        }
    }
    
    /// Returns URL constructed from specified directory
    static fileprivate func getURL(for directory: Directory, objectName: String) -> URL
    {
        var searchPathDirectory: FileManager.SearchPathDirectory
        
        switch directory
        {
            case .documents:
                searchPathDirectory = .documentDirectory
            case .caches:
                searchPathDirectory = .cachesDirectory
        }
        
        if var url = FileManager.default.urls(for: searchPathDirectory, in: .userDomainMask).first
        {
            //return url
            
            let contactID = Contact.MainID
            url.appendPathComponent("\(contactID)", isDirectory: true)
            url.appendPathComponent(environmentComponent(), isDirectory: true)
            url.appendPathComponent(objectName, isDirectory: true)
            //print("Storage URL: \(url)")
            return url
        }
        else
        {
            fatalError("Could not create URL for specified directory!")
        }
    }
    
    //MARK: - public functions
    
    /// Store an encodable struct to the specified directory on disk
    ///
    /// - Parameters:
    ///   - object: the encodable struct to store
    ///   - directory: where to store the struct
    static func store<T: CoreObjectProtocol>(_ object: T, to directory: Directory = .caches)
    {
        do
        {
            let directoryUrl = getURL(for: directory, objectName: String(describing: type(of: object)))
            //print("Storing \(object) to URL: \(directoryUrl)")
            if !FileManager.default.fileExists(atPath: directoryUrl.path)
            {
                //create directory
                try FileManager.default.createDirectory(atPath: directoryUrl.path, withIntermediateDirectories: true, attributes: nil)
            }
            let encoder = JSONEncoder()
            
            let data = try encoder.encode(object)
            let fileURL = directoryUrl.appendingPathComponent("\(object.id)", isDirectory: false)
            if FileManager.default.fileExists(atPath: fileURL.path)
            {
                try FileManager.default.removeItem(at: fileURL)
            }
            FileManager.default.createFile(atPath: fileURL.path, contents: data, attributes: nil)
        }
        catch
        {
            fatalError(error.localizedDescription)
        }
    }
    
    /// Retrieve and convert a struct from a file on disk
    ///
    /// - Parameters:
    ///   - id: the core object ID
    ///   - type: struct type (i.e. Contact.self)
    ///   - directory: directory where struct data is stored
    /// - Returns: decoded struct model(s) of data
    static func retrieve<T: CoreObjectProtocol>(_ id: Int, as type: T.Type, from directory: Directory = .caches) -> T?
    {
        let url = getURL(for: directory, objectName: "\(type.self)").appendingPathComponent("\(id)", isDirectory: false)
        
        if !FileManager.default.fileExists(atPath: url.path)
        {
            return nil
        }
        
        if let data = FileManager.default.contents(atPath: url.path)
        {
            let decoder = JSONDecoder()
            do
            {
                let model = try decoder.decode(type, from: data)
                return model
            }
            catch
            {
                fatalError(error.localizedDescription)
            }
        }
        else
        {
            fatalError("No data at \(url.path)!")
        }
    }
    
    /// Retrieve and convert structs from a all files of a given type in specified directory on disk
    ///
    /// - Parameters:
    ///   - type: struct type (i.e. Contact.self)
    ///   - directory: directory where struct data is stored
    /// - Returns: decoded struct model(s) of data
    static func retrieve<T: CoreObjectProtocol>(as type: T.Type, from directory: Directory = .caches) -> [T]
    {
        var filesArray: [T] = []
        let url = getURL(for: directory, objectName: "\(type.self)") 
        do
        {
            let files = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            for url in files
            {
                if let data = FileManager.default.contents(atPath: url.path)
                {
                    let decoder = JSONDecoder()
                    do
                    {
                        let model = try decoder.decode(type, from: data)
                        filesArray.append(model)
                    }
                    catch
                    {
                        //this file data is corrupt. Skip it.
                    }
                }
            }
            //print("FILES: \(files)")
        }
        catch
        {
            print(error)
        }
        
        //the order of the files returned by FileManager is undefined. So let's sort them here
        let files = filesArray.sorted(by: { $0.id < $1.id })
        for file in files
        {
            if let result = file as? Result
            {
                print("ID: \(result.id), \(result.wellnessScore)")
            }
        }
        return files
    }
    
    /// Remove all files of specified type at specified directory
    static func clear<T: CoreObjectProtocol>(objectType: T.Type, _ directory: Directory = .caches)
    {
        let url = getURL(for: directory, objectName: "\(objectType.self)")
        do
        {
            let contents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
            for fileUrl in contents
            {
                try FileManager.default.removeItem(at: fileUrl)
            }
        }
        catch
        {
            fatalError(error.localizedDescription)
        }
    }
    
    /// Remove specified file ID of object type from specified directory
    static func remove<T: CoreObjectProtocol>(_ id: Int, objectType: T.Type, from directory: Directory = .caches)
    {
        let url = getURL(for: directory, objectName: "\(objectType.self)").appendingPathComponent("\(id)", isDirectory: false)
        if FileManager.default.fileExists(atPath: url.path)
        {
            do
            {
                try FileManager.default.removeItem(at: url)
            }
            catch
            {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    /// Returns BOOL indicating whether file exists at specified directory with specified file name
    static func fileExists<T: CoreObjectProtocol>(_ id: Int, objectType: T.Type, in directory: Directory = .caches) -> Bool
    {
        let url = getURL(for: directory, objectName: "\(objectType.self)").appendingPathComponent("\(id)", isDirectory: false)
        return FileManager.default.fileExists(atPath: url.path)
    }
}
