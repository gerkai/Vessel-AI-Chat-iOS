//
//  IconCheckmarkView.swift
//  Vessel
//
//  Created by Carson Whitsett on 3/6/22.
//

import UIKit

protocol IconCheckmarkViewDelegate
{
    func checkmarkViewChecked(view: IconCheckmarkView)
}

class IconCheckmarkView: NibLoadingView
{
    @IBOutlet var contentView: UIView!
    @IBOutlet var roundedView: UIView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var iconImage: UIImageView!
    
    var originalColor: UIColor!
    var delegate: IconCheckmarkViewDelegate?
    var isUnchecking = false //set when quickly unchecking the checkbox w/o animation
    
    var defaultText: String?
    {
        didSet
        {
            textLabel.text = defaultText
        }
    }
    var isChecked: Bool = false
    {
        didSet
        {
            if isUnchecking
            {
                self.checkImage.image = UIImage(named: "checkbox_unselected")
                self.roundedView.backgroundColor = self.originalColor
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
                        self.checkImage.image = UIImage(named: "checkbox_selected")
                        self.roundedView.backgroundColor = UIColor.white
                    }
                    else
                    {
                        self.checkImage.image = UIImage(named: "checkbox_unselected")
                        self.roundedView.backgroundColor = self.originalColor
                    }
                    
                    UIView.animate(withDuration: 0.1, delay: 0, options: .beginFromCurrentState)
                    {
                        self.checkImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    }
                    completion:
                    { completed in
                        if self.isChecked == true
                        {
                            self.delegate?.checkmarkViewChecked(view: self)
                        }
                    }
                }
            }
        }
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        originalColor = roundedView.backgroundColor
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
}
