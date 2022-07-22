//
//  ScanViewController.swift
//  Scanner
//
//  Created by Carson Whitsett on 7/15/22.
//

import AVFoundation
import UIKit

class ScanViewController: TakeTestMVVMViewController, AVCaptureMetadataOutputObjectsDelegate, DrawingViewDelegate, AVCapturePhotoCaptureDelegate
{
    @IBOutlet weak var drawingView: DrawingView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var overlayTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var overlayBotConstraint: NSLayoutConstraint!
    @IBOutlet weak var darkenView: UIView!
    @IBOutlet weak var overlayView: UIImageView!
    
    var captureSession: AVCaptureSession!
    private var avCaptureDevice: AVCaptureDevice?
    private let avPhotoOutput = AVCapturePhotoOutput()
    var previewLayer: AVCaptureVideoPreviewLayer!
    var captureResolution: CGSize = CGSize()
    var goodAlignmentFrameCounter = 0
    var processingPhoto = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        cameraView.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo //allows us to shoot in RAW. Camera rez changes to 3024 x 4032!
        captureSession.automaticallyConfiguresCaptureDeviceForWideColor = false
        
        if let videoCaptureDevice = AVCaptureDevice.default(for: .video)
        {
            guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else{ return }

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
            
            print("Camera Resolution: \(drawingView.cameraSize)")
            
            //place the top and bottom of the overlay to match the top and bottom of the camera
            //let yOffset = overlayYConstraintValue(cameraSize: cameraSize)
            //overlayTopConstraint.constant = yOffset
            //overlayBotConstraint.constant = -yOffset
  
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.frame = cameraView.layer.bounds
            previewLayer.videoGravity = .resizeAspectFill
            cameraView.layer.addSublayer(previewLayer)

            captureSession.startRunning()
            UIApplication.shared.isIdleTimerDisabled = true
        }
    }

    deinit
    {
        print("ScanViewController deinit")
    }
    
    func overlayYConstraintValue(cameraSize: CGSize) -> CGFloat
    {
        let cWidth = cameraSize.width / UIScreen.main.scale
        let cHeight = cameraSize.height / UIScreen.main.scale

        let aspectScaleX = view.bounds.size.width / cWidth
        
        //(frameHeight - (frameW / CamW) * CamHeight) / 2
        //determine where in displayed image, the camera image starts vertically
        let yOffset = (view.bounds.height - (aspectScaleX * cHeight)) / 2
        return yOffset
    }
    
    override func viewDidLayoutSubviews()
    {
        previewLayer.frame = cameraView.bounds
        //print("Preview Frame: \(previewLayer.frame)")
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
            captureSession.startRunning()
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
        viewModel.curState.back()
        navigationController?.popViewController(animated: true)
    }
    
    private func getCaptureResolution(curVideoDevice: AVCaptureDevice) -> CGSize
    {
        // Define default resolution
        var resolution = CGSize(width: 0, height: 0)

        // Get cur video device
       // let curVideoDevice = useBackCamera ? backCameraDevice : frontCameraDevice

        // Set if video portrait orientation
        //let portraitOrientation = orientation == .Portrait || orientation == .PortraitUpsideDown

        // Get video dimensions
        let formatDescription = curVideoDevice.activeFormat.formatDescription
        
        let dimensions = CMVideoFormatDescriptionGetDimensions(formatDescription)
        resolution = CGSize(width: CGFloat(dimensions.width), height: CGFloat(dimensions.height))
        //if portraitOrientation
        //{
        //invert for portrait orientation
            resolution = CGSize(width: resolution.height, height: resolution.width)
        //}
        
        // Return resolution
        return resolution
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
        }
    }

    func found(code: String)
    {
        print(code)
    }

    override var prefersStatusBarHidden: Bool
    {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        return .portrait
    }
    
    //MARK: - DrawingView delegates
    func drawingStatus(isOnScreen: Bool, isCloseEnough: Int)
    {
        if !processingPhoto
        {
            if isCloseEnough > 0
            {
                noticeLabel.text = "Move further away"
                cameraView.backgroundColor = .red
                goodAlignmentFrameCounter = 0
            }
            else if isCloseEnough < 0
            {
                noticeLabel.text = "Move closer"
                cameraView.backgroundColor = .red
                goodAlignmentFrameCounter = 0
            }
            else if isOnScreen == false
            {
                noticeLabel.text = "Make sure entire card is in rectangle"
                cameraView.backgroundColor = .red
                goodAlignmentFrameCounter = 0
            }
            else
            {
                noticeLabel.text = ""
                cameraView.backgroundColor = .green
                goodAlignmentFrameCounter += 1
                if goodAlignmentFrameCounter > 30 //subjective
                {
                    noticeLabel.text = "Hold Still"
                    if goodAlignmentFrameCounter > 90 //subjective
                    {
                        noticeLabel.text = ""
                        goodAlignmentFrameCounter = 0
                        
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
            
            drawingView.qrBox = nil
            print("QR Box nil")
            drawingView.setNeedsDisplay()
            overlayView.isHidden = true
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
        captureSession.stopRunning()
        //vibrate phone when we capture image with QR code
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        /*if isManualMode,
           let data = photo.fileDataRepresentation(),
           let image = UIImage(data: data)
         {
            logicHandler.image = image
            logicHandler.qrCode = image.validQRCodeContent()
            
            let temporaryDirectoryURL = FileManager.default.temporaryDirectory
            let uniqueURL = temporaryDirectoryURL.appendingPathComponent(UUID().uuidString)
            logicHandler.rawImageFileURL = uniqueURL.appendingPathExtension("dng")
            isManualMode = false
            guard let rawURL = logicHandler.rawImageFileURL else { return }
            do
         {
                try photo.fileDataRepresentation()?.write(to: rawURL)
            }
         catch
         {
                showErrorAlert(error: "Error", description: "Error Capturing Card", buttonTitle: "Try Again")
                return
            }
            
            avSession.stopRunning()
            DispatchQueue.main.async
         {
                self.navigateToConfirmUploadingCard()
            }
            return
        }
        guard !isManualMode else { return }*/
        /*
        if error != nil
        {
            self.logicHandler.canBeginScanningCard = true
            self.logicHandler.isInCaptureLock = false
        }
        else
        {
            logicHandler.onCardCaptured(photo: photo)
            { [weak self] state in
                guard let self = self else { return }
                self.render(state: state)
            }
        }*/
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?)
    {
        print("DID FINISH CAPTURE FOR")
        captureSession.stopRunning()
        //vibrate phone when we capture image with QR code
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        //logicHandler.onImageProcessingFinished(then: render(state:))
    }
}
