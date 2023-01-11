//
//  FeedbackViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 1/10/23.
//

import UIKit

class FeedbackViewController: SlideupViewController, VesselScreenIdentifiable, UITextViewDelegate
{
    @Resolved internal var analytics: Analytics
    let flowName: AnalyticsFlowName = .appReviewFlow
    @IBOutlet weak var feedbackTextView: UITextView!
    @IBOutlet weak var remainingCharachterLabel: UILabel!
    @IBOutlet weak var submitButton: BounceButton!
    var originalSubmitColor: UIColor!
    let placeholderTextString = NSLocalizedString("Type your feedback here", comment: "")
    let characterLimit = 250 //the maximum number of characters a user can enter
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        originalSubmitColor = submitButton.backgroundColor
        enableSubmitButton(isEnabled: false)
        feedbackTextView.textContainerInset = UIEdgeInsets(top: 20, left: 28, bottom: 20, right: 28)
        setRemainingCharactersLabel(remaining: characterLimit)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("❇️ \(self)")
        }
    }
    
    deinit
    {
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("❌ \(self)")
        }
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func onSendFeedback()
    {
        analytics.log(event: .appReviewComments(text: feedbackTextView.text))
        
        //set flag that indicates contact has reviewed app experience
        let contact = Contact.main()!
        contact.flags |= Constants.HAS_RATED_APP
        ObjectStore.shared.clientSave(contact)
        
        //we don't need launch date in user defaults anymore.
        UserDefaults.standard.removeObject(forKey: Constants.KEY_FIRST_LAUNCH_DATE)
        
        dismissAnimation
        {
        }
    }
    
    @IBAction func onCloseButtonTapped()
    {
        //reset launch date so user will be prompted again at the next interval
        UserDefaults.standard.set(Date(), forKey: Constants.KEY_FIRST_LAUNCH_DATE)
        dismissAnimation
        {
        }
    }
    
    func enableSubmitButton(isEnabled: Bool)
    {
        submitButton.isEnabled = isEnabled
        if isEnabled
        {
            submitButton.backgroundColor = originalSubmitColor
        }
        else
        {
            submitButton.backgroundColor = Constants.vesselGray
        }
    }
    
    func setRemainingCharactersLabel(remaining: Int)
    {
        var count = remaining
        if count < 0
        {
            count = 0
        }
        if count == 1
        {
            remainingCharachterLabel.text = NSLocalizedString("1 character remaining", comment: "")
        }
        else
        {
            remainingCharachterLabel.text = NSLocalizedString("\(count) characters remaining", comment: "")
        }
    }
    
    @IBAction func dismissKeyboard()
    {
        feedbackTextView.resignFirstResponder()
    }
    
    //MARK: - textView delegates
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if textView.text == placeholderTextString
        {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if textView.text.isEmpty
        {
            textView.text = placeholderTextString
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        let textLength = textView.text.count
        //cw: borrowed from V2. This seems a little hokey :-\
        if let char = text.cString(using: String.Encoding.utf8)
        {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92)
            {
                if (textLength - 1) >= 0
                {
                    enableSubmitButton(isEnabled: true)
                    setRemainingCharactersLabel(remaining: characterLimit - textLength + 1)
                    return true
                }
                else
                {
                    enableSubmitButton(isEnabled: false)
                    setRemainingCharactersLabel(remaining: characterLimit)
                    return false
                }
            }
            else
            {
                if textLength + text.count <= characterLimit
                {
                    enableSubmitButton(isEnabled: true)
                    setRemainingCharactersLabel(remaining: characterLimit - textLength - text.count)
                    return true
                }
                else
                {
                    enableSubmitButton(isEnabled: true)
                    return false
                }
            }
        }
        else
        {
            setRemainingCharactersLabel(remaining: characterLimit - textLength)
            enableSubmitButton(isEnabled: true)
            if textLength < characterLimit
            {
                return true
            }
            else
            {
                return false
            }
        }
    }
    
    //MARK: - keyboard notifications
    @objc func keyboardWillShow(notification: NSNotification)
    {
        animateWithKeyboard(notification: notification)
        {(keyboardFrame) in
            self.popupBottom.constant = self.originalBottom - keyboardFrame.height + 34.0
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        animateWithKeyboard(notification: notification)
        {(keyboardFrame) in
            self.popupBottom.constant = self.originalBottom
        }
    }
    
    func animateWithKeyboard(notification: NSNotification, animations: ((_ keyboardFrame: CGRect) -> Void)?)
    {
        // Extract the duration of the keyboard animation
        let durationKey = UIResponder.keyboardAnimationDurationUserInfoKey
        let duration = notification.userInfo![durationKey] as! Double
        
        // Extract the final frame of the keyboard
        let frameKey = UIResponder.keyboardFrameEndUserInfoKey
        let keyboardFrameValue = notification.userInfo![frameKey] as! NSValue
        
        // Extract the curve of the iOS keyboard animation
        let curveKey = UIResponder.keyboardAnimationCurveUserInfoKey
        let curveValue = notification.userInfo![curveKey] as! Int
        let curve = UIView.AnimationCurve(rawValue: curveValue)!

        // Create a property animator to manage the animation
        let animator = UIViewPropertyAnimator(duration: duration, curve: curve)
        {
            // Perform the necessary animation layout updates
            animations?(keyboardFrameValue.cgRectValue)
            
            // Required to trigger NSLayoutConstraint changes
            // to animate
            self.view?.layoutIfNeeded()
        }
        // Start the animation
        animator.startAnimation()
    }
}
