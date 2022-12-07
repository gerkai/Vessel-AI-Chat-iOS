//
//  FoodCheckmarkView.swift
//  Vessel
//
//  Created by Nicolas Medina on 10/8/22.
//

import UIKit
import Kingfisher

protocol FoodCheckmarkViewDelegate: AnyObject
{
    func checkmarkViewTapped(view: FoodCheckmarkView)
    func checkmarkTapped(view: FoodCheckmarkView)
}

class FoodCheckmarkView: NibLoadingView
{
    // MARK: - Views
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var fadeView: UIView!
    @IBOutlet private weak var backgroundImage: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var servingLabel: UILabel!
    @IBOutlet private weak var checkImage: UIImageView!
    
    // MARK: - Model
    var food: Food?
    {
        didSet
        {
            backgroundImage.addSubview(fadeView)
            
            guard let food = food else { return }
            nameLabel.text = food.title
            
            if food.servingQuantity == Double(Int(food.servingQuantity))
            {
                servingLabel.text = "\(Int(food.servingQuantity)) \(food.servingUnit)"
            }
            else
            {
                servingLabel.text = "\(food.servingQuantity) \(food.servingUnit)"
            }

            if !hasSetGestureRecognizers
            {
                hasSetGestureRecognizers = true
                
                let viewGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onViewTapped))
                backgroundImage.addGestureRecognizer(viewGestureRecognizer)
                
                let checkmarkGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onCheckmarkTapped))
                checkImage.addGestureRecognizer(checkmarkGestureRecognizer)
            }
            
            let imageUrl = food.imageUrl
            let url = URL(string: imageUrl)
            backgroundImage.kf.setImage(with: url)
        }
    }
    
    weak var delegate: FoodCheckmarkViewDelegate?
    var hasSetGestureRecognizers = false
    
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
    
    private func checkmarkPressed()
    {
        isChecked = !isChecked
    }
    
    // MARK: - Actions
    @objc
    func onViewTapped(gestureRecognizer: UITapGestureRecognizer)
    {
        delegate?.checkmarkViewTapped(view: self)
    }
    
    @objc
    func onCheckmarkTapped(gestureRecognizer: UITapGestureRecognizer)
    {
        checkmarkPressed()
        delegate?.checkmarkTapped(view: self)
    }
}
