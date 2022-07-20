//
//  CaptureIntroViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/13/22.
//

import UIKit
import AVKit

class CaptureIntroViewController: TakeTestMVVMViewController
{
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var firstTipTextView: UITextView!
    private var playerViewController: AVPlayerViewController?
    var looper: AVPlayerLooper?
    private var startVideoDate: Date?
    private var videoThumbImage: UIImageView?
    private var isVideoObserved = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        scrollView.contentInsetAdjustmentBehavior = .never
        setupVideo()
        setupFirstTipTextView()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        // TODO: Add analytics for viewed page
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        navigationItem.setHidesBackButton(true, animated: false)
        playerViewController?.player?.play()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        playerViewController?.player?.pause()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?)
    {
        if keyPath == "rate", let player = object as? AVPlayer
        {
            if player.rate == 1
            {
                videoThumbImage?.removeFromSuperview()
            }
        }
    }

    deinit
    {
        if playerViewController?.player != nil, isVideoObserved
        {
            self.playerViewController?.player?.removeObserver(self, forKeyPath: "rate")
        }
    }

    private func setupFirstTipTextView()
    {
        let str = NSLocalizedString("Follow the video 👆 or\n test instructions to apply pee to all 18 squares.", comment: "")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.5
        let attributedString = NSMutableAttributedString(string: str, attributes: [NSAttributedString.Key.foregroundColor: UIColor.grayText, NSAttributedString.Key.font: UIFont(name: "NoeText-Book", size: 16.0)!, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        let foundRange = attributedString.mutableString.range(of: NSLocalizedString("test instructions", comment: "must match exactly 'test instructions' in the string 'Follow the video or test instructions to apply pee to all 18 squares.'"))
        attributedString.addAttribute(NSAttributedString.Key.link, value: "https://www.google.com", range: foundRange)
    //        attributedString.addAttributes([NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue], range: foundRange)
        let linkAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.grayText,
            NSAttributedString.Key.underlineColor: UIColor.grayText,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        firstTipTextView.linkTextAttributes = linkAttributes
        firstTipTextView.attributedText = attributedString
        firstTipTextView.delegate = self
    }
    
    func setupVideo()
    {
        let contact = Contact.main()!
        
        playerViewController = AVPlayerViewController()
        if let playerViewController = playerViewController
        {
            guard let mediaURL = Bundle.main.url(forResource: "test_card_tutorial", withExtension: "mp4") else {return}
            let player = AVQueuePlayer()
            looper = AVPlayerLooper(player: player, templateItem: AVPlayerItem(asset: AVAsset(url: mediaURL)))
            playerViewController.player = player
            playerViewController.view.frame = videoView.bounds
            addChild(playerViewController)
            videoView.addSubview(playerViewController.view)
            playerViewController.didMove(toParent: self)
            startVideoDate = Date()
            let videoWatchedBefore = contact.flags & Constants.WATCHED_INSTRUCTION_VIDEO
            if videoWatchedBefore != 0
            {
                playerViewController.showsPlaybackControls = true
                self.playerViewController?.player?.addObserver(self, forKeyPath: "rate", options: [], context: nil)
                self.isVideoObserved = true
            }
            else
            {
                playerViewController.showsPlaybackControls = false
                playerViewController.player?.play()
            }
        }
    }

    private func setThumbForVideo()
    {
        let contact = Contact.main()!
        //let userDefaultService = UserDefaults.standard
        let videoWatchedBefore = contact.flags & Constants.WATCHED_INSTRUCTION_VIDEO
        //let isVideoWatchedBefore = userDefaultService.bool(forKey: Constants.USER_WATCHED_INSTRUCTION_VIDEO)
        if videoWatchedBefore != 0
        {
            guard let mediaURL = Bundle.main.url(forResource: "test_card_tutorial", withExtension: "mp4") else {return}
            let asset = AVAsset(url: mediaURL)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
    //            let time = CMTimeMake(value: 10, timescale: 2)
    //            let imageRef = try! imageGenerator.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(named: "insrtuction_video_thumb") ?? UIImage()
            videoThumbImage = UIImageView(image: thumbnail)
            guard let videoThumbImage = videoThumbImage else{ return }
            videoThumbImage.contentMode = .scaleAspectFill
            guard let playerViewController = playerViewController else{ return }
            videoThumbImage.frame = playerViewController.videoBounds
            self.playerViewController?.contentOverlayView?.addSubview(videoThumbImage)
        }
    }
    
    @objc func onTextInstructionsTapped(gesture: UITapGestureRecognizer)
    {
        print("Text Instructions")
    }
    
    @IBAction func backButtonSelected(_ sender: Any)
    {
        viewModel.curState.back()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func seeTipsButton(_ sender: Any)
    {
        //let storyboard = UIStoryboard(name: "Capture", bundle: nil)
        //let vc = storyboard.instantiateViewController(identifier: "DripsTipsViewController") as! DripsTipsViewController
        //navigationController?.pushViewController(vc, animated: true)
        print("TIPS")
    }
    
    @IBAction func startTimerSelected(_ sender: Any)
    {
        /*let passedTime = Int(Date().timeIntervalSince(self.startVideoDate ?? Date()))
        let minimumTimeWatchingVideo = 104
        let userDefaultService = UserDefaults.standard
        let isUserWatchedVideoBefore = userDefaultService.bool(forKey: Constants.USER_WATCHED_INSTRUCTION_VIDEO)
        if passedTime > minimumTimeWatchingVideo ||
            isUserWatchedVideoBefore ||
            UserDefaultsFix.shared.getTestCount() > 0 {
            userDefaultService.setValue(true, forKey: Constants.USER_WATCHED_INSTRUCTION_VIDEO)
            trackStartTimerEvent()
            navigateUserToTest()
        } else
        {
            playerViewController?.player?.pause()
            let storyboard = UIStoryboard(name: "Tip", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "WatchInstructionVideoTipViewController") as! WatchInstructionVideoTipViewController
            
            customPresentViewController(customPresenter, viewController: vc, animated: true)
            vc.onDismiss = {[weak self] in
                self?.playerViewController?.player?.play()
                userDefaultService.setValue(true, forKey: Constants.USER_WATCHED_INSTRUCTION_VIDEO)
            }
            
        }*/
    }
}
    
extension CaptureIntroViewController: UITextViewDelegate
{
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool
    {
        let storyboard = UIStoryboard(name: "TakeTest", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "TipInstructionsViewController") as! TipInstructionsViewController
        navigationController?.pushViewController(vc, animated: true)
        
        return false
    }
}
