//
//  TakeTestViewModel.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/13/22.
//

import UIKit

//this enum determines the order the take test screens will appear
enum TakeTextState: Int
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
        self = TakeTextState(rawValue: rawValue + 1) ?? .Initial
        print("Incrementing to state: \(self)")
    }
    
    mutating func back()
    {
        self = TakeTextState(rawValue: rawValue - 1) ?? .Initial
    }
}

class TakeTestViewModel
{
    var curState: TakeTextState = .Initial
    
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
        else
        {
            //show capture intro
            let vc = storyboard.instantiateViewController(withIdentifier: "CaptureIntroViewController") as! CaptureIntroViewController
            vc.viewModel = viewModel
            return vc
        }
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
}
