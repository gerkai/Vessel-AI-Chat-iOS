//
//  ActivateCardViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/18/22.
//

import UIKit

class ActivateCardViewController: TakeTestMVVMViewController, TakeTestViewModelDelegate
{
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var preTimerView: UIView!
    @IBOutlet weak var postTimerView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var firstTimeAppeared = false
    var curSeconds = Int(Constants.CARD_ACTIVATION_SECONDS)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        viewModel.delegate = self
        postTimerView.alpha = 0.0
        backButton.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        if !firstTimeAppeared
        {
            firstTimeAppeared = true
            viewModel.startTimer()
        }
    }
    
    @IBAction func onBackButton()
    {
        viewModel.curState.back()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSkipButton()
    {
        let storyboard = UIStoryboard(name: "TakeTest", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SkipTimerPopupViewController") as! SkipTimerPopupViewController
        self.present(vc, animated: false)
    }
    
    //MARK: - ViewModel delegates
    func timerUpdate(secondsRemaining: Double, timeUp: Bool)
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
        
        if timeUp
        {
            titleLabel.text = NSLocalizedString("It's time to scan your card", comment: "")
            UIView.animate(withDuration: 0.25, delay: 0.0)
            {
                self.postTimerView.alpha = 1.0
                self.preTimerView.alpha = 0.0
                self.backButton.alpha = 1.0
            }
        }
    }
}
