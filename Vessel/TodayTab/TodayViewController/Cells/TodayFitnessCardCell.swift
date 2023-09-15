//
//  TodayFitnessCardCell.swift
//  Vessel
//
//  Created by v.martin.peshevski on 14.9.23.
//

import UIKit

class TodayFitnessCardCell: UITableViewCell
{
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var checkImage: UIImageView!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var thirdLabel: UILabel!
    
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
        if let description = description
        {
            descriptionLabel?.text = description
        }
        checkImage.image = completed ? UIImage(named: "Checkbox_beige_selected") : UIImage(named: "Checkbox_beige_unselected")
        
        checkImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCheckMarkSelected)))
        
        isChecked = completed
        guard let url = URL(string: backgroundImage) else
        {
            assertionFailure("TodayCheckMarkCardTableViewCell-setup: backgroundImage not a valid URL")
            return
        }
        backgroundImageView.kf.setImage(with: url)
        configureUI(with: ["Calories", "Exercise", "Standing"])
    }
    
    func configureUI(with names: [String])
    {
        configureCategory(button: firstButton, value: 22, progress: 0.33, progressColor: .white)
        configureCategory(button: secondButton, value: 30, progress: 1.0, progressColor: .black)
        configureCategory(button: thirdButton, value: 6, progress: 0.66, progressColor: .white)
        
        names.enumerated().forEach
        { (index, name) in
            if index == 0
            {
                firstLabel.text = name
            }
            if index == 1
            {
                secondLabel.text = name
            }
            if index == 2
            {
                thirdLabel.text = name
            }
        }
    }
    
    func configureCategory(button: UIButton, value: Int, progress: Float, progressColor: UIColor)
    {
        let progressView = RingProgressView(frame: CGRect(x: 0, y: 0, width: button.frame.width + 5, height: button.frame.height + 5), lineWidth: 2, cornerRadius: 15)
        progressView.progressColor = progressColor
        progressView.trackColor = .clear
        progressView.progress = progress
        
        button.titleLabel?.text = String(value)
        button.layer.cornerRadius = 14
        button.addSubview(progressView)
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
}
    
