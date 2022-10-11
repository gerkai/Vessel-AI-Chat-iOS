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
    @IBOutlet private weak var button: UIButton!
    
    // MARK: - Model
    var food: Food?
    {
        didSet
        {
            backgroundImage.addSubview(fadeView)
            button.setTitle("", for: .normal)
            
            guard let food = food else { return }
            nameLabel.text = food.title
            servingLabel.text = "\(Int(food.serving_quantity)) \(food.serving_unit)"
            
            guard let url = URL(string: food.image_url) else { return }
            backgroundImage.kf.setImage(with: url)
        }
    }
    
    var originalColor: UIColor!
    weak var delegate: FoodCheckmarkViewDelegate?
    var isUnchecking = false
    
    var isChecked: Bool = false
    {
        didSet
        {
            if isUnchecking
            {
                self.checkImage.image = UIImage(named: "Checkbox_beige_unselected")
                self.backgroundImage.backgroundColor = self.originalColor
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
                        self.backgroundImage.backgroundColor = UIColor.white
                    }
                    else
                    {
                        self.checkImage.image = UIImage(named: "Checkbox_beige_unselected")
                        self.backgroundImage.backgroundColor = self.originalColor
                    }
                    
                    UIView.animate(withDuration: 0.1, delay: 0, options: .beginFromCurrentState)
                    {
                        self.checkImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    }
                }
            }
        }
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        originalColor = backgroundImage.backgroundColor
    }
    
    @IBAction func checkmarkPressed()
    {
        isChecked = !isChecked
    }
    
    func uncheck()
    {
        if isChecked == true
        {
            isUnchecking = true
            isChecked = false
        }
    }
    
    // MARK: - Actions
    
    @IBAction func onViewTapped()
    {
        delegate?.checkmarkViewTapped(view: self)
    }
}
