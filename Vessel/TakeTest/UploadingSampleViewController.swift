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

class UploadingSampleViewController: TakeTestMVVMViewController, PopupErrorViewControllerDelegate
{
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    private var animationView: AnimationView?
    private var retryCount = 0
    let maxRetryCount = 20
    var sampleUUID: String!
    var delegate: UploadingSampleViewControllerDelegate?
    
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
        //if let fileData = viewModel.photo?.fileDataRepresentation()
        //{
            if let contact = Contact.main()
            {
                sampleUUID = UUID().uuidString
                let parameters = TestUUID(uuid: sampleUUID, wellnessCardUUID: viewModel.cardQRCode, autoScan: true, replacementParentUUID: nil)
                
                //print("Parameters: \(parameters)")
                Server.shared.associateTestUUID(parameters: parameters)
                { cardAssociation in
                    //print("ASSOCIATION BATCH ID: \(String(describing: cardAssociation.cardBatchID))")
                    //print("calibrationMode: \(String(describing: cardAssociation.cardCalibrationMode))")
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
                    print("\(error)")
                }
            }
            else
            {
                print("Contact not available")
            }
       // }
    }
    
    private func uploadToS3(fileData: Data, orcaName: String?, uuid: String, contactID: String, batchID: String? = nil, calibrationMode: String? = nil)
    {        
        TestCardUploader.shared.uploadImage(with: fileData, uuid: uuid, contactID: contactID, orcaName: orcaName, batchID: batchID, calibrationMode: calibrationMode, progressBlock:
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
                    self.showUploadingError()
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
            showProcessingError(testUUID: sampleUUID)
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
            if testResult.errors.count == 0
            {
                let storyboard = UIStoryboard(name: "AfterTest", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "ResultsViewController") as! ResultsViewController
                vc.testResult = testResult
                self.viewModel.uploadingFinished()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                print("Error in object response: \(testResult)")
            }
        }
        onFailure:
        { error in
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
                            print("The error is: \(error)")
                        }
                    }
                }
            }
        }
    }
    
    private func showUploadingError()
    {
        //analyticManager.trackEvent(eventName: "image_capture_error_upload_fail", properties: nil)
        let alert = UIAlertController(title: "Error", message: "Upload failed. Tap OK to retry.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Retry action"), style: .default, handler:
        { _ in
            self.uploadImage()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel action"), style: .cancel, handler: { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }))
        alert.showOverTopViewController()
    }
    
    private func showProcessingError(testUUID: String)
    {
        let alert = UIAlertController(title: "Error", message: NSLocalizedString("Failed to process. Tap OK to retry.", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Retry action"), style: .default, handler:
        { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel action"), style: .cancel, handler:
        { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }))
        alert.showOverTopViewController()
    }
    
    private func showCropFailurePopup()
    {
        let vc = PopupErrorViewController.instantiate(title: NSLocalizedString("Apologies, we had a hard time reading your card", comment: ""), message: NSLocalizedString("This could be due to shadow, glare or droplets. Simply check your card, your lighting, and let's give it another shot.", comment: ""), topButtonTitle: "", botButtonTitle: "Try Again", delegate: self)
        present(vc, animated: false)
    }
    
    private func showOtherErrorPopup()
    {
        let vc = PopupErrorViewController.instantiate(title: NSLocalizedString("Apologies, we had a hard time uploading your card", comment: ""), message: NSLocalizedString("Please try again.", comment: ""), topButtonTitle: "", botButtonTitle: "Try Again", delegate: self)
        present(vc, animated: false)
    }
    
    //MARK: - PopupErrorViewController delegates
    func popupErrorDone(button: PopupErrorButton)
    {
        delegate?.retryScan()
        viewModel.uploadingFinished()
        viewModel.curState.back()
        navigationController?.popViewController(animated: true)
    }
}
