//
//  PopupErrorViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/24/22.
//

import UIKit

enum PopupErrorButton
{
    case Top
    case Bottom
}

protocol PopupErrorViewControllerDelegate
{
    func popupErrorDone(button: PopupErrorButton)
}

class PopupErrorViewController: UIViewController
{
    @IBOutlet weak var darkenView: UIView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var popupBottom: NSLayoutConstraint!
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var botButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    var delegate: PopupErrorViewControllerDelegate?
    var originalBottom: CGFloat!
    var titleString: String!
    var message: String!
    var topButtonTitle: String!
    var botButtonTitle: String!
    
    static func instantiate(title: String, message: String, topButtonTitle: String, botButtonTitle: String, delegate: PopupErrorViewControllerDelegate) -> PopupErrorViewController
    {
        let storyboard = UIStoryboard(name: "TakeTest", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PopupErrorViewController") as! PopupErrorViewController
        vc.titleString = title
        vc.message = message
        vc.topButtonTitle = topButtonTitle
        vc.botButtonTitle = botButtonTitle
        vc.delegate = delegate
        
        return vc
    }
    
    override func viewDidLoad()
    {
        titleLabel.text = titleString
        messageLabel.text = message
        topButton.setTitle(topButtonTitle, for: .normal)
        botButton.setTitle(botButtonTitle, for: .normal)
        
        darkenView.alpha = 0.0
        originalBottom = popupBottom.constant
        popupBottom.constant = view.bounds.height + popupView.frame.height
        
        if topButtonTitle.count == 0
        {
            topButton.isHidden = true
        }
        if botButtonTitle.count == 0
        {
            botButton.isHidden = true
        }
        super.viewDidLoad()
    }
    
    deinit
    {
        print("📘 PopupErrorViewController deinit")
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
    
    func dismissAnimation(button: PopupErrorButton) -> Void
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
            self.delegate?.popupErrorDone(button: button)
        }
    }
    
    @IBAction func onTopButton()
    {
        dismissAnimation(button: .Top)
    }
    
    @IBAction func onBotButton()
    {
        dismissAnimation(button: .Bottom)
    }
}
