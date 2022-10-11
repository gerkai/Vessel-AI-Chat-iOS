//
//  ActivateCardViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/18/22.
//
//  Note: Segmented control background color is broken as of iOS 13. We can't set a pure white background color. It ends up being gray. See this article: https://rdovhaliuk.medium.com/ios-13-uisegmentedcontrol-3-important-changes-d3a94fdd6763
//
//  Add -DLOOP_VIDEOS to Other Swift Flags in build settings for looped videos

import UIKit
import AVKit

class ActivateCardViewController: TakeTestMVVMViewController, TakeTestViewModelDelegate, SkipTimerSlideupViewControllerDelegate, VesselScreenIdentifiable
{
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var preTimerView: UIView!
    @IBOutlet weak var postTimerView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressAmount: NSLayoutConstraint!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressDot: UIImageView!
    @IBOutlet weak var segmentedControl: VesselSegmentedControl!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var tabDetailsLabel: UILabel!
    
    var flowName: AnalyticsFlowName = .takeTestFlow
    @Resolved internal var analytics: Analytics
    
    private var playerViewController: AVPlayerViewController?
#if LOOP_VIDEOS
    var looper: AVPlayerLooper?
#endif
    var player1: AVPlayer!
    var player2: AVPlayer!
    
    var firstTimeAppeared = false
    var curSeconds = Int(Constants.CARD_ACTIVATION_SECONDS)
    var skipTimerSlideupVC: SkipTimerSlideupViewController?
    
    //segmented control indices
    let IntroIndex = 0
    let TourIndex = 1
    let InsightsIndex = 2
    let defaultSegmentDetailsString = NSLocalizedString("Your Wellness Test Card", comment: "")
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupVideo()
        postTimerView.alpha = 0.0
        backButton.alpha = 0.0
        
        //this fixes it but it's too aggressive and you can no longer read the text of the selected segment.
        //segmentedControl.setBackgroundImage(UIImage.init(named: "whiteImage"), for: .normal, barMetrics: .default)
        
        self.segmentedControl.layer.backgroundColor = UIColor.white.cgColor
        self.segmentedControl.backgroundColor = UIColor.white
        
        segmentedControl.setImage(UIImage.textEmbeded(image: UIImage.init(named: "PlayIcon")!, string: NSLocalizedString("Intro", comment: "Segmented Control button title"), isImageBeforeText: true), forSegmentAt: 0)
        segmentedControl.setImage(UIImage.textEmbeded(image: UIImage.init(named: "PlayIcon")!, string: NSLocalizedString("Tour", comment: "Segmented Control button title"), isImageBeforeText: true), forSegmentAt: 1)
        segmentedControl.setImage(UIImage.textEmbeded(image: UIImage.init(named: "InsightsIcon")!, string: NSLocalizedString("Insights", comment: "Segmented Control button title"), isImageBeforeText: true), forSegmentAt: 2)
        
        tabDetailsLabel.text = defaultSegmentDetailsString
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        viewModel.delegate = self
        if !firstTimeAppeared
        {
            /*segmentedControl.subviews.forEach
            { subview in
             // subview.backgroundColor = .white
                print("Color: \(subview.layer.backgroundColor)")
            }*/
            firstTimeAppeared = true
            viewModel.startTimer()
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        playerViewController?.player?.play()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        playerViewController?.player?.pause()
    }
    
    func setupVideo()
    {
        playerViewController = AVPlayerViewController()
        if let playerViewController = playerViewController
        {
            if let mediaURL = MediaManager.shared.localPathForFile(filename: Constants.timerFirstVideo)
            {
#if LOOP_VIDEOS
                player1 = AVQueuePlayer()
                looper = AVPlayerLooper(player: player1, templateItem: AVPlayerItem(asset: AVAsset(url: mediaURL)))
#else
                player1 = AVPlayer(url: mediaURL)
            
#endif
            }
            if let mediaURL = MediaManager.shared.localPathForFile(filename: Constants.timerSecondVideo)
            {
#if LOOP_VIDEOS
                player2 = AVQueuePlayer()
                looper = AVPlayerLooper(player: player2, templateItem: AVPlayerItem(asset: AVAsset(url: mediaURL)))
#else
                player2 = AVPlayer(url: mediaURL)
            
#endif
            }
            
            playerViewController.player = player1
            playerViewController.view.frame = videoView.bounds
            addChild(playerViewController)
            videoView.addSubview(playerViewController.view)
            playerViewController.didMove(toParent: self)

            playerViewController.showsPlaybackControls = true
        }
    }
    
    @IBAction func onBackButton()
    {
        viewModel.delegate = nil
#if LOOP_VIDEOS
        looper?.disableLooping()
        looper = nil
#endif
        playerViewController?.player?.pause()
        //playerViewController?.removeFromParent()
        //playerViewController?.view.removeFromSuperview()
        playerViewController = nil
        
        viewModel.curState.back()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSkipButton()
    {
        let storyboard = UIStoryboard(name: "TakeTest", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SkipTimerSlideupViewController") as! SkipTimerSlideupViewController
        vc.delegate = self
        self.present(vc, animated: false)
        skipTimerSlideupVC = vc
    }
    
    @IBAction func onScanButton()
    {
        viewModel.delegate = nil
        let vc = viewModel.nextViewController()
        if (viewModel.curState == .Capture) && (UserDefaults.standard.bool(forKey: Constants.KEY_BYPASS_SCANNING) == true)
        {
            let storyboard = UIStoryboard(name: "AfterTest", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ResultsNavController") as! UINavigationController
            let root = vc.viewControllers[0] as! ResultsViewController
            root.mockTestResult()
            self.navigationController?.pushViewController(root, animated: true)
        }
        else
        {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func insightsText() -> String
    {
        guard let contact = Contact.main() else { return "" }
        
        var goalsString = ""
        contact.goal_ids.forEach { goalID in
            if let key = Goal.ID(rawValue: goalID), let goalName = Goals[key]?.name
            {
                goalsString += goalID == contact.goal_ids.first ? "" : goalID == contact.goal_ids.last ? " and " : ", "
                goalsString += goalName
            }
        }
        
        let text = String(format: NSLocalizedString("Learn how to improve your %@ while you wait", comment: ""), goalsString)
        return text
    }
    
    //MARK: - Segmented Control action
    @IBAction func onSegmentChoice(_ sender: UISegmentedControl)
    {
        switch sender.selectedSegmentIndex
        {
            case IntroIndex:
                tabDetailsLabel.text = defaultSegmentDetailsString
                player2.pause()
                playerViewController?.player = player1
                player1.play()
                videoView.isHidden = false
            case TourIndex:
                tabDetailsLabel.text = defaultSegmentDetailsString
                player1.pause()
                playerViewController?.player = player2
                player2.play()
                videoView.isHidden = false
            default:
                player1.pause()
                player2.pause()
                videoView.isHidden = true
                tabDetailsLabel.text = insightsText()
        }
    }
    
    //MARK: - ViewModel delegates
    func timerUpdate(secondsRemaining: Double, percentageElapsed: Double, timeUp: Bool)
    {
        let secsRemaining = Int(secondsRemaining)
        if secsRemaining != curSeconds
        {
            curSeconds = secsRemaining
            let minutes = Int(secondsRemaining) / 60 % 60
            let seconds = Int(secondsRemaining) % 60
            let string = String(format: "%2i:%02i", minutes, seconds)
            timerLabel.text = string
        }
        progressAmount.constant = percentageElapsed * (progressView.frame.width - progressDot.frame.width)
        
        if timeUp
        {
            skipTimerSlideupVC?.onCancel()
            titleLabel.text = NSLocalizedString("It's time to scan your card", comment: "")
            UIView.animate(withDuration: 0.25, delay: 0.0)
            {
                self.postTimerView.alpha = 1.0
                self.preTimerView.alpha = 0.0
                self.backButton.alpha = 1.0
            }
        }
    }
    
    //MARK: - SkipTimeSlideup delegates
    func skipTimerSlideupDone(proceedToSkip: Bool)
    {
        skipTimerSlideupVC = nil
        if proceedToSkip
        {
            viewModel.skipTimer()
            viewModel.delegate = nil
        }
    }
}
