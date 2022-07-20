//
//  MediaManager.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/20/22.
//  Simple media manager that downloads media files from server and stores them in the documents directory
//  for use by the app.
//  TODO: Add versioning which will allow us to update media files on the server and have the app re-download them.

import Foundation

class MediaManager: NSObject
{
    static let shared = MediaManager()
    
    var nextMediaIndex = 0
    let mediaFiles = [Constants.testCardTutorialVideo, Constants.timerFirstVideo, Constants.timerSecondVideo]

    func initMedia()
    {
        nextMediaIndex = 0
        downloadNextMedia()
    }
    
    func downloadNextMedia()
    {
        if let fileName = nextMediaToDownload()
        {
            //download the video
            downloadMedia(fileName: fileName)
            { success, error in
                if success == true
                {
                    self.nextMediaIndex += 1
                    self.downloadNextMedia()
                    print ("Successfully download \(fileName)")
                }
                else
                {
                    print ("File Download Error: \(String(describing: error))")
                }
            }
        }
    }

    func nextMediaToDownload() -> String?
    {
        if nextMediaIndex < mediaFiles.count
        {
            let fileName = mediaFiles[nextMediaIndex]
            if fileExists(filename: fileName)
            {
                nextMediaIndex += 1
                return nextMediaToDownload()
            }
            return fileName
        }
        else
        {
            return nil
        }
    }
    
    func downloadMedia(fileName: String, completion: @escaping (_ success: Bool, _ error: Error?) ->())
    {
        if let path = URL(string: Constants.mediaPath + "/" + fileName)
        {
            //print("URL: \(path)")
            FileDownloader.loadFileAsync(url: path)
            { savedPath, error in
                //print("savedPath: \(savedPath)")
                if error == nil
                {
                    completion(true, error)
                }
                else
                {
                    completion(false, error)
                }
            }
        }
    }
    
    func localPathForFile(filename: String) -> URL?
    {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent(filename)
        {
            return pathComponent
        }
        return nil
    }

    func fileExists(filename: String) -> Bool
    {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent(filename)
        {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath)
            {
                return true
            }
        }
        return false
    }
}
