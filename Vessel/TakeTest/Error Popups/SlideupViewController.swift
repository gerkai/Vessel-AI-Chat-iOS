//
//  SlideupViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 9/6/22.
//

import UIKit

class SlideupViewController: UIViewController
{
    @IBOutlet weak var darkenView: UIView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var popupBottom: NSLayoutConstraint!
    var originalBottom: CGFloat!
    
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
            self.popupBottom.constant = self.originalBottom - 30.0 //overshoot a little bit
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
    
    func dismissAnimation(done: @escaping () -> Void)
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
            done()
        }
    }
}
