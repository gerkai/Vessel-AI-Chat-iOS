//
//  TodayCheckMarkCardTableViewCell.swift
//  Vessel
//
//  Created by Nicolas Medina on 9/27/22.
//

import UIKit

protocol TodayCheckMarkCardDelegate: AnyObject
{
    func onCardChecked(id: Int, checked: Bool, type: CheckMarkCardType)
    func canUncheckCard(type: CheckMarkCardType) -> Bool
    func animationComplete()
    func onReminderTapped(id: Int, type: CheckMarkCardType)
}

class TodayCheckMarkCardTableViewCell: UITableViewCell
{
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var checkImage: UIImageView!
    @IBOutlet private weak var notificationButton: UIButton!
    @IBOutlet private weak var notificationButtonLabel: UILabel!
    @IBOutlet private weak var notificationButtonBackground: UIVisualEffectView!
    
    var id: Int?
    var type: CheckMarkCardType?
    weak var delegate: TodayCheckMarkCardDelegate?
    
    override func prepareForReuse()
    {
        isChecked = false
    }
    
    var isChecked: Bool = false
    {
        didSet
        {
            checkImage.image = isChecked ? UIImage(named: "Checkbox_beige_selected") : UIImage(named: "Checkbox_beige_unselected")
        }
    }

    func setup(title: String,
               subtitle: String,
               description: String?,
               backgroundImage: String,
               completed: Bool,
               remindersButtonState: Bool? = nil,
               remindersButtonTitle: String? = nil,
               id: Int? = nil,
               type: CheckMarkCardType? = nil,
               delegate: TodayCheckMarkCardDelegate? = nil)
    {
        self.id = id
        self.type = type
        self.delegate = delegate
        titleLabel.text = title
        subtitleLabel.text = subtitle
        if let description = description
        {
            descriptionLabel?.text = description
        }
        //checkImage.image = completed ? UIImage(named: "Checkbox_beige_selected") : UIImage(named: "Checkbox_beige_unselected")
        
        checkImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCheckMarkSelected)))
        
        notificationButton?.isHidden = !(remindersButtonState != nil)
        notificationButtonBackground?.isHidden = !(remindersButtonState != nil)
        notificationButton?.setImage(remindersButtonState ?? false ? UIImage(named: "reminders-icon-on") : UIImage(named: "reminders-icon"), for: .normal)
        notificationButtonLabel?.isHidden = !(remindersButtonState ?? false)
        notificationButtonLabel?.text = remindersButtonTitle?.convertTo12HourFormat() ?? remindersButtonTitle
        
        isChecked = completed
        guard let url = URL(string: backgroundImage) else
        {
            assertionFailure("TodayCheckMarkCardTableViewCell-setup: backgroundImage not a valid URL")
            return
        }
        backgroundImageView.kf.setImage(with: url)
    }
    
    func animateChecked()
    {
        if !isChecked
        {
            self.checkImage.image = UIImage(named: "Checkbox_beige_unselected")
            DispatchQueue.main.async
            {
                self.delegate?.animationComplete()
            }
        }
        else
        {
            //animate checkmark
            UIView.animate(withDuration: 0.1, delay: 0, options: .beginFromCurrentState)
            {
                self.checkImage.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
        completion:
            { completed in
                self.checkImage.image = UIImage(named: "Checkbox_beige_selected")
                
                UIView.animate(withDuration: 0.1, delay: 0, options: .beginFromCurrentState)
                {
                    self.checkImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
            completion:
                {
                    _ in
                    DispatchQueue.main.async
                    {
                        self.delegate?.animationComplete()
                    }
                }
            }
        }
    }
    
    @objc
    func onCheckMarkSelected(gestureRecognizer: UIGestureRecognizer)
    {
        guard let id = id,
              let type = type,
              let delegate = delegate else { return }
        if isChecked == false
        {
            if type != .lifestyleRecommendation && type != .lesson
            {
                isChecked = true
            }
            animateChecked()
            delegate.onCardChecked(id: id, checked: isChecked, type: type)
        }
        else
        {
            if delegate.canUncheckCard(type: type)
            {
                isChecked = false
                delegate.onCardChecked(id: id, checked: isChecked, type: type)
            }
        }
    }
    
    @IBAction func onReminderButtonTapped()
    {
        guard let id = id,
              let type = type,
              let delegate = delegate else { return }

        delegate.onReminderTapped(id: id, type: type)
    }
}
