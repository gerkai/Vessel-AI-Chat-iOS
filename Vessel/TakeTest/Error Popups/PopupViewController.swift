//
//  PopupViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 9/6/22.
//

import UIKit

class PopupViewController: UIViewController
{
    @IBOutlet weak var darkenView: UIView!
    @IBOutlet weak var popupView: UIView!
    var flowName: AnalyticsFlowName = .takeTestFlow
    @Resolved internal var analytics: Analytics
    
    override func viewDidLoad()
    {
        darkenView.alpha = 0.0
        popupView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut)
        {
            self.darkenView.alpha = 1.0
            self.popupView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.view.layoutIfNeeded()
        }
        completion:
        { _ in
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut)
            {
                self.popupView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
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
            self.popupView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            self.view.layoutIfNeeded()
        }
        completion:
        { _ in
            self.dismiss(animated: false)
            done()
        }
    }
}
