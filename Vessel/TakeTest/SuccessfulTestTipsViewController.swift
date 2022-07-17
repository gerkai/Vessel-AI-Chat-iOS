//
//  SuccessfulTestTipsViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/12/22.
//

import UIKit

class SuccessfulTestTipsViewController: TakeTestMVVMViewController, IconCheckmarkViewDelegate
{
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var botViewHeight: NSLayoutConstraint!
    @IBOutlet weak var topView: IconCheckmarkView!
    @IBOutlet weak var botView: IconCheckmarkView!
    
    let smallScreenCheckmarkHeight = 100.0 //reduce checkmark heights on small screens so they'll fit better
    
    let peeInCupTag = 0
    let peeOnCardTag = 1
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //reduce height on checkboxes so they fit on smaller screen w/o needing to scroll
        if view.frame.height < Constants.SMALL_SCREEN_HEIGHT_THRESHOLD
        {
            topViewHeight.constant = smallScreenCheckmarkHeight
            botViewHeight.constant = smallScreenCheckmarkHeight
        }
        topView.tag = peeInCupTag
        topView.delegate = self
        topView.iconImage.image = UIImage.init(named: "PeeInCup-icon")
        topView.textLabel.text = NSLocalizedString("Sounds good,\nI'll use a cup", comment: "")
        
        botView.tag = peeOnCardTag
        botView.delegate = self
        botView.iconImage.image = UIImage.init(named: "PeeOnCard-icon")
        botView.textLabel.text = NSLocalizedString("I'd rather pee\ndirectly on it", comment: "")
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func back()
    {
        viewModel.curState.back()
        dismiss(animated: true)
    }
    
    //MARK: - IconCheckmarkView delegates
    func checkmarkViewChecked(view: IconCheckmarkView)
    {
        if view.tag == peeInCupTag
        {
            let storyboard = UIStoryboard(name: "TakeTest", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CupTipViewController") as! CupTipViewController
            vc.initWithViewModel(vm: viewModel)
            navigationController?.fadeTo(vc)
            botView.isChecked = false
        }
        else
        {
            let storyboard = UIStoryboard(name: "TakeTest", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PeeTipViewController") as! PeeTipViewController
            vc.initWithViewModel(vm: viewModel)
            navigationController?.fadeTo(vc)
            topView.isChecked = false
        }
    }
}
