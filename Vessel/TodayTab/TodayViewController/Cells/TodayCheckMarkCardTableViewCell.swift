//
//  TodayCheckMarkCardTableViewCell.swift
//  Vessel
//
//  Created by Nicolas Medina on 9/27/22.
//

import UIKit

protocol TodayCheckMarkCardDelegate: AnyObject
{
    func onCardChecked(id: Int, type: CheckMarkCardType)
    func canUncheckCard(type: CheckMarkCardType) -> Bool
}

class TodayCheckMarkCardTableViewCell: UITableViewCell
{
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var checkImage: UIImageView!
    
    var id: Int?
    var type: CheckMarkCardType?
    weak var delegate: TodayCheckMarkCardDelegate?
    
    var isUnchecking = false
    var isChecked: Bool = false
    {
        didSet
        {
            if !isChecked
            {
                self.checkImage.image = UIImage(named: "Checkbox_beige_unselected")
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
                    if self.isChecked == true
                    {
                        self.checkImage.image = UIImage(named: "Checkbox_beige_selected")
                    }
                    else
                    {
                        self.checkImage.image = UIImage(named: "Checkbox_beige_unselected")
                    }
                    
                    UIView.animate(withDuration: 0.1, delay: 0, options: .beginFromCurrentState)
                    {
                        self.checkImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    }
                }
            }
        }
    }

    func setup(title: String,
               subtitle: String,
               description: String?,
               backgroundImage: String,
               completed: Bool,
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
        checkImage.image = completed ? UIImage(named: "Checkbox_beige_selected") : UIImage(named: "Checkbox_beige_unselected")
        
        checkImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCheckMarkSelected)))
        
        guard let url = URL(string: backgroundImage) else { return }
        backgroundImageView.kf.setImage(with: url)
    }
    
    @objc
    func onCheckMarkSelected(gestureRecognizer: UIGestureRecognizer)
    {
        guard let id = id,
              let type = type,
              let delegate = delegate else { return }
        if isChecked == false
        {
            isChecked = true
            delegate.onCardChecked(id: id, type: type)
        }
        else
        {
            if delegate.canUncheckCard(type: type)
            {
                isChecked = false
                delegate.onCardChecked(id: id, type: type)
            }
        }
    }
}
