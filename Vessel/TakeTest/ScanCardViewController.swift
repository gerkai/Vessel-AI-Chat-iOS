//
//  ScanCardViewController.swift
//
//  Created by Carson Whitsett on 7/15/22.
//

import AVFoundation
import UIKit

class ScanCardViewController: TakeTestMVVMViewController, AVCaptureMetadataOutputObjectsDelegate, DrawingViewDelegate, AVCapturePhotoCaptureDelegate, UploadingSampleViewControllerDelegate
{
    @IBOutlet weak var drawingView: DrawingView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var darkenView: UIView!
    @IBOutlet weak var postCaptureView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var cardView: UIView!
    
    var captureSession: AVCaptureSession!
    private var avCaptureDevice: AVCaptureDevice?
    private let avPhotoOutput = AVCapturePhotoOutput()
    var previewLayer: AVCaptureVideoPreviewLayer!
    var captureResolution: CGSize = CGSize()
    var processingPhoto = false
    weak var clearTimer: Timer?
    var clearTimerCount = 0
    var holdStillTime: CFTimeInterval?
    var cameraOpenTime: CFTimeInterval!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        postCaptureView.alpha = 0.0
        cameraView.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo //allows us to shoot in RAW. Camera rez changes to 3024 x 4032!
        captureSession.automaticallyConfiguresCaptureDeviceForWideColor = false
 
        if UserDefaults.standard.bool(forKey: Constants.KEY_SHOW_DEBUG_DRAWING) == true
        {
            drawingView.showDebugDrawing = true
        }
        
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInUltraWideCamera], mediaType: AVMediaType.video, position: .back)
        if let captureDevice = deviceDiscoverySession.devices.first, UIDevice.isIphone14
        {
            avCaptureDevice = captureDevice
        }
        else
        {
            avCaptureDevice = AVCaptureDevice.default(for: .video)
        }

        if let videoCaptureDevice = avCaptureDevice
        {
            guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else
            {
                assertionFailure("ScanCardViewController-viewDidLoad: Couldn't find video capture device input")
                return
            }
            
            do
            {
                try videoCaptureDevice.lockForConfiguration()
                
                if (videoCaptureDevice.isAutoFocusRangeRestrictionSupported)
                {
                    videoCaptureDevice.autoFocusRangeRestriction = .near
                }
                videoCaptureDevice.unlockForConfiguration()
            }
            catch
            {
            }
            
            if (captureSession.canAddInput(videoInput))
            {
                captureSession.addInput(videoInput)
            }
            else
            {
                failed()
                return
            }
            
            let metadataOutput = AVCaptureMetadataOutput()

            if (captureSession.canAddOutput(metadataOutput))
            {
                captureSession.addOutput(metadataOutput)

                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = [.qr]
            }
            else
            {
                failed()
                return
            }
            
            captureSession.addOutput(avPhotoOutput)
            let cameraSize = getCaptureResolution(curVideoDevice: videoCaptureDevice)
            drawingView.cameraSize = cameraSize
            drawingView.delegate = self
             
            //print("Camera Resolution: \(drawingView.cameraSize)")
  
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.frame = cameraView.layer.bounds
            previewLayer.videoGravity = .resizeAspectFill
            cameraView.layer.addSublayer(previewLayer)

            DispatchQueue.global(qos: .userInitiated).async
            {
                self.captureSession.startRunning()
            }
            UIApplication.shared.isIdleTimerDisabled = true
        }
    }
    
    override func viewDidLayoutSubviews()
    {
        previewLayer?.frame = cameraView.bounds
        drawingView.validArea = cardView.frame
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        cameraOpenTime = CACurrentMediaTime()
        clearTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true)
        {
           _ in self.onTick()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        clearTimer?.invalidate()
        clearTimer = nil
    }
    
    func onTick()
    {
        if clearTimerCount > 0
        {
            clearTimerCount -= 1
            if clearTimerCount == 0
            {
                noticeLabel.text = ""
                noticeLabel.backgroundColor = .clear
                drawingView.qrBox = nil
                drawingView.setNeedsDisplay()
            }
        }
    }
    
    func failed()
    {
        let ac = UIAlertController(title: NSLocalizedString("Scanning not supported", comment: ""), message: NSLocalizedString("Your device does not support scanning a code from an item. Please use a device with a camera.", comment: ""), preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false)
        {
            DispatchQueue.global(qos: .userInitiated).async
            {
                self.captureSession.startRunning()
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true)
        {
            captureSession.stopRunning()
        }
    }

    @IBAction func onBackButton()
    {
        UIApplication.shared.isIdleTimerDisabled = false
        captureSession.stopRunning()
        viewModel.curState.back()
        navigationController?.popViewController(animated: true)
        drawingView.delegate = nil
    }
    
    private func getCaptureResolution(curVideoDevice: AVCaptureDevice) -> CGSize
    {
        // Define default resolution
        var resolution = CGSize(width: 0, height: 0)

        // Get video dimensions
        let formatDescription = curVideoDevice.activeFormat.formatDescription
        
        let dimensions = CMVideoFormatDescriptionGetDimensions(formatDescription)
        resolution = CGSize(width: CGFloat(dimensions.width), height: CGFloat(dimensions.height))

        //swap width and height for portrait orientation
        resolution = CGSize(width: resolution.height, height: resolution.width)
        
        // Return resolution
        return resolution
    }
    
    @IBAction func onLooksGood()
    {
        analytics.log(event: .sampleImageConfirmed(cardUUID: viewModel.cardQRCode))
        UIApplication.shared.isIdleTimerDisabled = false
        let vc = viewModel.nextViewController()
        
        if let vc1 = vc as? UploadingSampleViewController
        {
            vc1.delegate = self
        }
        navigationController?.pushViewController(vc, animated: true)
        drawingView.delegate = nil
    }
    
    @IBAction func onRetake()
    {
        DispatchQueue.global(qos: .userInitiated).async
        {
            self.captureSession.startRunning()
        }
        darkenView.alpha = 0.0
        darkenView.isHidden = false
        processingPhoto = false
        drawingView.delegate = self
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear)
        {
            self.postCaptureView.alpha = 0.0
            self.backButton.alpha = 1.0
            self.darkenView.alpha = 1.0
        }
        completion:
        { _ in
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection)
    {
        if let metadataObject = metadataObjects.first
        {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else
            {
                return
            }
            guard let stringValue = readableObject.stringValue else
            {
                return
            }
            if processingPhoto == false
            {
                drawingView.qrBox = readableObject.corners
                
                found(code: stringValue)
            }
            else
            {
                drawingView.qrBox = nil
            }
            drawingView.setNeedsDisplay()
            clearTimerCount = 10 //1 second
        }
    }

    func found(code: String)
    {
        //print(code)
        viewModel.cardQRCode = code
    }
    
    //MARK: - DrawingView delegates
    func drawingStatus(isOnScreen: Bool, isCloseEnough: Int, upsideDown: Bool)
    {
        if !processingPhoto
        {
            noticeLabel.backgroundColor = .white
            if upsideDown == true
            {
                noticeLabel.text = NSLocalizedString("Card is upside down", comment: "Card placement instructions for user")
                cameraView.backgroundColor = .red
                noticeLabel.backgroundColor = Constants.vesselPoor
                holdStillTime = nil
            }
            else if isCloseEnough > 0
            {
                noticeLabel.text = NSLocalizedString("Move further away", comment: "Card placement instructions for user")
                cameraView.backgroundColor = .red
                holdStillTime = nil
            }
            else if isCloseEnough < 0
            {
                noticeLabel.text = NSLocalizedString("Move closer", comment: "Card placement instructions for user")
                cameraView.backgroundColor = .red
                holdStillTime = nil
            }
            else if isOnScreen == false
            {
                noticeLabel.text = NSLocalizedString("Make sure entire card is in rectangle", comment: "Card placement instructions for user")
                cameraView.backgroundColor = .red
                holdStillTime = nil
            }
            else
            {
                noticeLabel.text = ""
                noticeLabel.backgroundColor = .clear
                cameraView.backgroundColor = .green
                if holdStillTime == nil
                {
                    holdStillTime = CACurrentMediaTime()
                }
                
                let timeDelta = CACurrentMediaTime() - holdStillTime!
                
                if timeDelta > 1.0 //subjective
                {
                    noticeLabel.text = NSLocalizedString("Card detected, hold still", comment: "Card placement instructions for user")
                    noticeLabel.backgroundColor = Constants.vesselGreat
                    if timeDelta > 2.0 //subjective
                    {
                        noticeLabel.text = ""
                        holdStillTime = nil
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1)
                        {
                            self.captureCard()
                        }
                    }
                }
            }
        }
    }

    func captureCard()
    {
        if let availableRawFormat = self.avPhotoOutput.availableRawPhotoPixelFormatTypes.first
        {
            processingPhoto = true
            
            viewModel.cardQRCoordinates = drawingView.qrBoxPercentages()
            drawingView.qrBox = nil
            drawingView.setNeedsDisplay()
            darkenView.isHidden = true
            
            let photoSettings = AVCapturePhotoSettings(rawPixelFormatType: availableRawFormat, processedFormat: [AVVideoCodecKey: AVVideoCodecType.jpeg])
            //saving parameters for use by uploader later. We'll do this a different way.
            if let captureDevice = avCaptureDevice
            {
                UserDefaults.standard.set(captureDevice.iso, forKey: "ExposureISO")
                UserDefaults.standard.set(CMTimeGetSeconds(captureDevice.exposureDuration) * 1000, forKey: "ExposureDuration")
            }
            avPhotoOutput.capturePhoto(with: photoSettings, delegate: self)
            photoSettings.flashMode = .off
            photoSettings.isHighResolutionPhotoEnabled = false
        }
    }
    
    //MARK: - AVCapturePhotoCapture Delegate
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?)
    {
        print("DID FINISH PROCESSING PHOTO. Error: \(String(describing: error)), output: \(output), photo: \(photo)")
        if error == nil
        {
            if photo.isRawPhoto
            {
                print("Processing Raw Photo")
                viewModel.photo = photo
            }
            else
            {
                print("Processing Regular Photo")
                if let compressedImageData = photo.fileDataRepresentation()
                {
                    viewModel.compressedPhoto = compressedImageData
                }
            }
        }
        else
        {
            print("Photo Processing Error: \(String(describing: error))")
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?)
    {
        let captureTime = CACurrentMediaTime() - cameraOpenTime
        let captureTimeMS = Int(captureTime * 1000.0)
        analytics.log(event: .sampleImageCaptured(attemptTimeMs: captureTimeMS, cardUUID: viewModel.cardQRCode))
        print("DID FINISH CAPTURE")
        if error == nil
        {
            captureSession.stopRunning()
            
            //vibrate phone when we capture image with QR code
            //AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear)
            {
                self.postCaptureView.alpha = 1.0
                self.backButton.alpha = 0.0
            }
            completion:
            { _ in
            }
        }
        else
        {
            print("Photo Capture Error: \(String(describing: error))")
        }
    }
    
    //MARK: UploadingSampleViewController delegates
    func retryScan()
    {
        UIApplication.shared.isIdleTimerDisabled = true
        onRetake()
    }
}
