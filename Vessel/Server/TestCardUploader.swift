//
//  TestCardUploader.swift
//  vessel-ios
//
//  Created by Paul Wong on 4/18/20.
//  Copyright © 2020 Vessel Health Inc. All rights reserved.
//

import AWSS3
import UIKit

class TestCardUploader
{
    static let shared = TestCardUploader()
    
    func modelIdentifier() -> String
    {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
    
    func uploadCalibrationImage(with data: Data,
                                image: UIImage?,
                                uuid: String,
                                orcaName: String?,
                                secondsSinceExposure: Int,
                                pictureNumber: Int,
                                progressBlock: @escaping AWSS3TransferUtilityProgressBlock,
                                completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?)
    {
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = progressBlock
        addBasicMetadata(expression: expression)
        
        uploadImage(with: data,
                    orcaName: orcaName,
                    uuid: uuid,
                    expression: expression,
                    completionHandler: completionHandler)
    }
    
    func uploadImage(with data: Data,
                     uuid: String,
                     contactID: String,
                     orcaName: String?,
                     batchID: String?,
                     calibrationMode: String?,
                     qrBox: [CGPoint],
                     progressBlock: @escaping AWSS3TransferUtilityProgressBlock,
                     completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?)
    {
        let expression = AWSS3TransferUtilityUploadExpression()
        
        //add QR code coordinates to image metadata
        expression.setValue("\(qrBox[0].x), \(qrBox[0].y)", forRequestParameter: "x-amz-meta-qr-topleft")
        expression.setValue("\(qrBox[1].x), \(qrBox[1].y)", forRequestParameter: "x-amz-meta-qr-bottomleft")
        expression.setValue("\(qrBox[2].x), \(qrBox[2].y)", forRequestParameter: "x-amz-meta-qr-bottomright")
        expression.setValue("\(qrBox[3].x), \(qrBox[3].y)", forRequestParameter: "x-amz-meta-qr-topright")
        
        addBasicMetadata(expression: expression)
        addCardAssociationProvidedMetadata(batchID: batchID,
                                           calibrationMode: calibrationMode,
                                           expression: expression)
        
        expression.progressBlock = progressBlock
    
        uploadImage(with: data,
                    orcaName: orcaName,
                    uuid: uuid,
                    expression: expression,
                    completionHandler: completionHandler)
    }
    
    func uploadImageJPG(jpegData: Data?,
                     uuid: String,
                     contactID: String,
                     orcaName: String?,
                     batchID: String?,
                     calibrationMode: String?,
                     progressBlock: AWSS3TransferUtilityProgressBlock?,
                     completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?)
    {
        let expression = AWSS3TransferUtilityUploadExpression()
        
        addBasicMetadata(expression: expression)
        addCardAssociationProvidedMetadata(batchID: batchID,
                                           calibrationMode: calibrationMode,
                                           expression: expression)
        
        expression.progressBlock = progressBlock
    
        uploadImageJPG(/*with: data,*/
                    orcaName: orcaName,
                    jpegData: jpegData,
                    uuid: uuid,
                    expression: expression,
                    completionHandler: completionHandler)
    }
    
    private func uploadImage(with data: Data,
                             orcaName: String? /*,
                             image: UIImage?*/,
                             uuid: String,
                             expression: AWSS3TransferUtilityUploadExpression,
                             completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?)
    {
        /* cw temp commented out
        expression.setValue(orcaName ?? "", forRequestParameter: "x-amz-meta-orca-sheet-name")
        */

        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: Constants.AWS.accessKey,
                                                               secretKey: Constants.AWS.secretKey)
        let configuration = AWSServiceConfiguration(region: AWSRegionType.USWest2,
                                                    credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        print("uploading file: \(uuid).dng")
        AWSS3TransferUtility.default().uploadData(
            data,
            bucket: Constants.AWS.WellnessSampleImagesBucket,
            key: "\(uuid).dng",
            contentType: "image/x-adobe-dng",
            expression: expression,
            completionHandler: completionHandler).continueWith
        {(task) -> AnyObject? in
            return nil
        }
    }
    
    private func uploadImageJPG(/*with data: Data,*/
                                orcaName: String?,
                                jpegData: Data?,
                                uuid: String,
                                expression: AWSS3TransferUtilityUploadExpression,
                                completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?)
    {
/* CW temp commented out
        let qrMetaDataGenerator = QRMetaDataGenerator(image: image)
        
        if let metaData = qrMetaDataGenerator.generateMetaData()
        {
            expression.setValue("\(metaData.topLeft.x),\(metaData.topLeft.y)", forRequestParameter: "x-amz-meta-qr-topleft")
            expression.setValue("\(metaData.topRight.x),\(metaData.topRight.y)", forRequestParameter: "x-amz-meta-qr-topright")
            expression.setValue("\(metaData.bottomLeft.x),\(metaData.bottomLeft.y)", forRequestParameter: "x-amz-meta-qr-bottomleft")
            expression.setValue("\(metaData.bottomRight.x),\(metaData.bottomRight.y)", forRequestParameter: "x-amz-meta-qr-bottomright")
        }
        expression.setValue(orcaName ?? "", forRequestParameter: "x-amz-meta-orca-sheet-name")
        */

        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: Constants.AWS.accessKey,
                                                               secretKey: Constants.AWS.secretKey)
        let configuration = AWSServiceConfiguration(region: AWSRegionType.USWest2, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration

        if let jpegData = jpegData
        {
                AWSS3TransferUtility.default().uploadData(
                    jpegData,
                    bucket: Constants.AWS.WellnessSampleImagesBucket,
                    key: "\(uuid).jpeg",
                    contentType: "image/jpeg",
                    expression: expression,
                    completionHandler: nil)
        }
    }
    
    private func addBasicMetadata(expression: AWSS3TransferUtilityUploadExpression)
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let exposureISO = UserDefaults.standard.float(forKey: "ExposureISO")
        expression.setValue("\(exposureISO)", forRequestParameter: "x-amz-meta-exposure-iso")
        
        let exposureDuration = UserDefaults.standard.float(forKey: "ExposureDuration")
        expression.setValue("\(exposureDuration)", forRequestParameter: "x-amz-meta-exposure-duration-ms")

        expression.setValue("\(formatter.string(from: Date()))", forRequestParameter: "x-amz-meta-image-capture-date")
        
        let os = ProcessInfo().operatingSystemVersion
        expression.setValue("\(os.majorVersion).\(os.minorVersion).\(os.patchVersion)", forRequestParameter: "x-amz-meta-os-version")
        
        // metadata for current app version, e.g. 1.0.6.130
        if let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String, let currentBuildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        {
            expression.setValue("\(currentVersion).\(currentBuildNumber)", forRequestParameter: "x-amz-meta-app-version")
        }
        expression.setValue("\(modelIdentifier())", forRequestParameter: "x-amz-meta-phone-model")
        
        if let contactId = Contact.main()?.id //UserManager.shared.contact?.id
        {
            expression.setValue(String(contactId), forRequestParameter: "x-amz-meta-contact-id")
            print("contactId: \(contactId)")
        }
        
        expression.setValue("2.0", forRequestParameter: "x-amz-meta-card-version")
    }
    
    private func addCardAssociationProvidedMetadata(batchID: String?, calibrationMode: String?, expression: AWSS3TransferUtilityUploadExpression)
    {
        if let batchId = batchID
        {
            expression.setValue("\(batchId)", forRequestParameter: "x-amz-meta-wellness-card-batch-id")
        }
        
        if let calibrationMode = calibrationMode
        {
            expression.setValue(calibrationMode, forRequestParameter: "x-amz-meta-calibration-mode")
        }
    }
}
