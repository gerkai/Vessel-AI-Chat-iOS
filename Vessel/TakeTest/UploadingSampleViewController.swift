//
//  UploadingSampleViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/23/22.
//

import UIKit
import Lottie

struct TestUUID: Encodable
{
    let uuid: String //sample UUID
    let wellnessCardUUID: String
    let autoScan: Bool
    let replacementParentUUID: String?
    
    enum CodingKeys: String, CodingKey
    {
        case uuid
        case wellnessCardUUID = "wellness_card_uuid"
        case autoScan = "auto_scan"
        case replacementParentUUID = "replacement_parent_uuid"
    }
}

protocol UploadingSampleViewControllerDelegate
{
    func retryScan()
}

enum PopupErrorType: Int
{
    case cropFailure
    case alreadyScanned
    case calibrationError
    case otherError
}

class UploadingSampleViewController: TakeTestMVVMViewController, AlreadyScannedSlideupViewControllerDelegate, CalibrationErrorSlideupViewControllerDelegate, InvalidQRSlideupViewControllerDelegate, UploadErrorSlideupViewControllerDelegate, CropFailureSlideupViewControllerDelegate, VesselScreenIdentifiable
{
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    private var animationView: LottieAnimationView?
    private var retryCount = 0
    let maxRetryCount = 20
    var sampleUUID: String!
    var delegate: UploadingSampleViewControllerDelegate?
    
    @Resolved internal var analytics: Analytics
    let flowName: AnalyticsFlowName = .takeTestFlow
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        uploadImage()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        playAnimation()
    }
    
    func playAnimation()
    {
        animationView = .init(name: "test_result_flow_p1")
        animationView!.frame = loadingView.frame
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .playOnce
        animationView!.animationSpeed = 1.0
        view.addSubview(animationView!)
        animationView!.play
        {[weak self] (isFinished) in
            if isFinished
            {
                self?.replayAnimation()
            }
        }
    }
    
    @objc func replayAnimation()
    {
        animationView = .init(name: "test_result_flow_p2")
        animationView!.frame = loadingView.frame
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 1.0
        view.addSubview(animationView!)
        animationView!.play()
    }
    
    private func uploadImage()
    {
        if let contact = Contact.main()
        {
            sampleUUID = UUID().uuidString
            let parameters = TestUUID(uuid: sampleUUID, wellnessCardUUID: viewModel.cardQRCode, autoScan: true, replacementParentUUID: nil)
            
            //print("Parameters: \(parameters)")
            Server.shared.associateTestUUID(parameters: parameters)
            { cardAssociation in
                //print("ASSOCIATION BATCH ID: \(String(describing: cardAssociation.cardBatchID))")
                //print("calibrationMode: \(String(describing: cardAssociation.cardCalibrationMode))")
                //self.showCropFailurePopup()
                //return
                
                if let fileData = self.viewModel.photo?.fileDataRepresentation()
                {
                    self.uploadToS3(
                        fileData: fileData,
                        orcaName: cardAssociation.orcaSheetName,
                        uuid: parameters.uuid,
                        contactID: String(contact.id),
                        batchID: cardAssociation.cardBatchID,
                        calibrationMode: cardAssociation.cardCalibrationMode
                    )
                }
            }
            onFailure:
            { error in
                if error.code == 400
                {
                    if error.description == "Card already scanned successfully"
                    {
                        self.showAlreadyScannedPopup()
                    }
                    else
                    {
                        self.showOtherErrorPopup()
                    }
                }
                else
                {
                    if error.code == 404
                    {
                        self.showInvalidQRCodePopup()
                    }
                    else
                    {
                        self.showCalibrationError(statusCode: error.code)
                    }
                }
            }
        }
        else
        {
            print("Contact not available")
        }
    }
    
    private func uploadToS3(fileData: Data, orcaName: String?, uuid: String, contactID: String, batchID: String? = nil, calibrationMode: String? = nil)
    {        
        TestCardUploader.shared.uploadImage(with: fileData, uuid: uuid, contactID: contactID, orcaName: orcaName, batchID: batchID, calibrationMode: calibrationMode, qrBox: viewModel.cardQRCoordinates, progressBlock:
        { [weak self](task, progress) in
            DispatchQueue.main.async(execute:
            {[weak self] in
                guard let self = self else{ return }
                self.percentLabel.text = "\(Int(progress.fractionCompleted * 100)) %"
                if Int(progress.fractionCompleted * 100) == 100
                {
                    self.titleLabel.text = NSLocalizedString("You are moments away from getting your results", comment: "")
                    self.percentLabel.text = ""
                }
            })
        })
        { [weak self] (task, error) in
            guard let self = self else{ return }
            if let error = error
            {
                print("Upload Image error: \(error)")

                DispatchQueue.main.async(execute:
                {
                    self.showOtherErrorPopup()
                })
            }
            else
            {
                //print("Uploaded image")
                TestCardUploader.shared.uploadImageJPG(jpegData: self.viewModel.compressedPhoto, uuid: uuid, contactID: contactID, orcaName: orcaName, batchID: batchID, calibrationMode: calibrationMode, progressBlock: nil, completionHandler: nil)
                DispatchQueue.main.async(execute:
                {
                    self.pollForTestResults()
                })
            }
        }
    }
    
    private func pollForTestResults()
    {
        self.statusLabel.text = NSLocalizedString("Processing image...", comment: "")
        self.percentLabel.text = ""
        if retryCount >= maxRetryCount
        {
            showOtherErrorPopup()
            retryCount = 0
            return
        }
        print("Polling... \(retryCount)")
        retryCount += 1
        getScore()
    }
    
    private func getScore()
    {
        Server.shared.getScore(sampleID: sampleUUID)
        { testResult in
            let storyboard = UIStoryboard(name: "AfterTest", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ResultsViewController") as! ResultsViewController
            vc.testResult = testResult
            
            //save Result to objectStore
            ObjectStore.shared.serverSave(testResult)
            
            self.viewModel.uploadingFinished()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        onFailure:
        { error in
            //print("The error is: \(error)")
            if let error = error as? NSError
            {
                if error.code == 404
                {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2))
                    {
                        self.pollForTestResults()
                    }
                }
                else
                {
                    DispatchQueue.main.async
                    {
                        if error.code == 19
                        {
                            self.showCropFailurePopup()
                        }
                        else
                        {
                            self.showOtherErrorPopup()
                        }
                    }
                }
            }
        }
    }
    
    private func showCropFailurePopup()
    {
        let storyboard = UIStoryboard(name: "TakeTest", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CropFailureSlideupViewController") as! CropFailureSlideupViewController
        vc.delegate = self
        self.present(vc, animated: false)
    }
    
    private func showAlreadyScannedPopup()
    {
        let storyboard = UIStoryboard(name: "TakeTest", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AlreadyScannedSlideupViewController") as! AlreadyScannedSlideupViewController
        vc.delegate = self
        self.present(vc, animated: false)
    }
    
    private func showCalibrationError(statusCode: Int)
    {
        let storyboard = UIStoryboard(name: "TakeTest", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CalibrationErrorSlideupViewController") as! CalibrationErrorSlideupViewController
        vc.delegate = self
        self.present(vc, animated: false)
    }
    
    private func showInvalidQRCodePopup()
    {
        let storyboard = UIStoryboard(name: "TakeTest", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "InvalidQRSlideupViewController") as! InvalidQRSlideupViewController
        vc.delegate = self
        self.present(vc, animated: false)
    }
    
    private func showOtherErrorPopup()
    {
        let storyboard = UIStoryboard(name: "TakeTest", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UploadErrorSlideupViewController") as! UploadErrorSlideupViewController
        vc.delegate = self
        self.present(vc, animated: false)
    }
    
    //MARK: - AlreadyScanedSlideupViewController delegates
    func alreadyScannedCustomerSupport()
    {
        ZendeskManager.shared.navigateToChatWithSupport(in: self)
    }
    
    func alreadyScannedScanNewCard()
    {
        self.retryScan()
    }
    
    //MARK: - CalibrationErrorSlideupViewController delegates
    func calibrationErrorCustomerSupport()
    {
        ZendeskManager.shared.navigateToChatWithSupport(in: self)
    }
    
    //MARK: - InvalidQRSlideupViewController delegates
    func invalidQRTryAgain()
    {
        self.retryScan()
    }
    
    private func retryScan()
    {
        delegate?.retryScan()
        viewModel.uploadingFinished()
        viewModel.curState.back()
        navigationController?.popViewController(animated: true)
    }
}
