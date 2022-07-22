//
//  TakeTestViewModel.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/13/22.
//

import UIKit

protocol TakeTestViewModelDelegate
{
    func timerUpdate(secondsRemaining: Double, percentageElapsed: Double, timeUp: Bool)
}

//this enum determines the order the take test screens will appear
enum TakeTestState: Int
{
    case Initial
    case TestTips
    case CaptureIntro
    case ActivateCard
    case AfterPeeTips
    case Capture
    case Upload
    
    mutating func next()
    {
        self = TakeTestState(rawValue: rawValue + 1) ?? .Initial
        print("Incrementing to state: \(self)")
    }
    
    mutating func back()
    {
        self = TakeTestState(rawValue: rawValue - 1) ?? .Initial
        print("Decrementing to state: \(self)")
    }
}

class TakeTestViewModel
{
    var curState: TakeTestState = .Initial
    var activationTimer: Timer?
    var activationTimeRemaining = 0.0
    var percentageElapsed = 0.0
    let activationTimerInterval = 0.1 /* seconds. How often updates are sent to VC */
    var delegate: TakeTestViewModelDelegate?
    var timerStartDate: Date!
    
    //MARK: - navigation
    static func NextViewController(viewModel: TakeTestViewModel) -> TakeTestMVVMViewController
    {
        //MainContact is guaranteed
        let contact = Contact.main()!
        
        let storyboard = UIStoryboard(name: "TakeTest", bundle: nil)
        
        //increment to next state
        viewModel.curState.next()
        
        //skip tips if user opted to not show them
        if viewModel.curState == .TestTips
        {
            if contact.flags & Constants.HIDE_PEE_TIPS != 0
            {
                viewModel.curState = .CaptureIntro
            }
        }
        if viewModel.curState == .TestTips
        {
            //show pee tips
            let vc = storyboard.instantiateViewController(withIdentifier: "SuccessfulTestTipsViewController") as! SuccessfulTestTipsViewController
            vc.viewModel = viewModel
            return vc
        }
        if viewModel.curState == .CaptureIntro
        {
            //show capture intro
            let vc = storyboard.instantiateViewController(withIdentifier: "CaptureIntroViewController") as! CaptureIntroViewController
            vc.viewModel = viewModel
            return vc
        }
        if viewModel.curState == .ActivateCard
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "ActivateCardViewController") as! ActivateCardViewController
            vc.viewModel = viewModel
            return vc
        }
        if viewModel.curState == .AfterPeeTips
        {
            if contact.flags & Constants.HIDE_DROPLET_TIPS != 0
            {
                viewModel.curState = .Capture
            }
            else
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "ScanningDropletsTipViewController") as! ScanningDropletsTipViewController
                vc.viewModel = viewModel
                return vc
            }
        }
       
        let vc = storyboard.instantiateViewController(withIdentifier: "ScanCardViewController") as! ScanCardViewController
        vc.viewModel = viewModel
        return vc
    }
    
    func nextViewController() -> TakeTestMVVMViewController
    {
        return TakeTestViewModel.NextViewController(viewModel: self)
    }
    
    func shouldShowTips() -> Bool
    {
        let contact = Contact.main()!
        if contact.flags & Constants.HIDE_PEE_TIPS == 0
        {
            return true
        }
        return false
    }
    
    func hideTips()
    {
        let contact = Contact.main()!
        contact.flags |= Constants.HIDE_PEE_TIPS
    }
    
    func hideDropletTips()
    {
        let contact = Contact.main()!
        contact.flags |= Constants.HIDE_DROPLET_TIPS
    }
    
    func startTimer()
    {
        timerStartDate = Date()
        var expired = false
        let totalTime = Constants.CARD_ACTIVATION_SECONDS
        activationTimer = Timer.scheduledTimer(withTimeInterval: activationTimerInterval, repeats: true, block:
        { timer in
            var interval = Date().timeIntervalSince(self.timerStartDate)

            self.percentageElapsed = interval / totalTime
            if interval > Constants.CARD_ACTIVATION_SECONDS
            {
                interval = Constants.CARD_ACTIVATION_SECONDS
                self.stopTimer()
                expired = true
            }

            self.delegate?.timerUpdate(secondsRemaining: totalTime - interval, percentageElapsed: self.percentageElapsed, timeUp: expired)
        })
    }
    
    func stopTimer()
    {
        activationTimer?.invalidate()
        activationTimer = nil
        activationTimeRemaining = 0.0
    }
    
    func skipTimer()
    {
        stopTimer()
        self.percentageElapsed = 1.0
        self.delegate?.timerUpdate(secondsRemaining: self.activationTimeRemaining, percentageElapsed: self.percentageElapsed, timeUp: true)
    }
}
