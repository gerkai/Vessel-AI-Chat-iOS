//
//  SkipTimerPopupViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/18/22.
//

import UIKit

protocol SkipTimerPopupViewControllerDelegate
{
    func skipTimerPopupDone(proceedToSkip: Bool)
}

class SkipTimerPopupViewController: UIViewController
{
    @IBOutlet weak var darkenView: UIView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var popupBottom: NSLayoutConstraint!
    var canceling = true
    var originalBottom: CGFloat!
    var delegate: SkipTimerPopupViewControllerDelegate?
    
    override func viewDidLoad()
    {
        darkenView.alpha = 0.0
        originalBottom = popupBottom.constant
        popupBottom.constant = view.bounds.height + popupView.frame.height
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut)
        {
            self.darkenView.alpha = 1.0
            self.popupBottom.constant = self.originalBottom - 120.0 //overshoot a little bit
            self.view.layoutIfNeeded()
        }
        completion:
        { _ in
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut)
            {
                self.popupBottom.constant = self.originalBottom
                self.view.layoutIfNeeded()
            }
            completion:
            { _ in
            }
        }
    }
    
    func dismissAnimation() -> Void
    {
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseIn)
        {
            self.darkenView.alpha = 0.0
            self.popupBottom.constant = self.view.bounds.height + self.popupView.frame.height
            self.view.layoutIfNeeded()
        }
        completion:
        { _ in
            self.dismiss(animated: false)
            self.delegate?.skipTimerPopupDone(proceedToSkip: self.canceling)
        }
    }
    
    @IBAction func onContinue()
    {
       canceling = false
        dismissAnimation()
    }
    
    @IBAction func onCancel()
    {
        dismissAnimation()
    }
}
