//
//  FoodFilterCollectionViewCell.swift
//  vessel-ios
//
//  Created by Mohamed El-Taweel on 1/27/21.
//  Copyright © 2021 Vessel Health Inc. All rights reserved.
//

import UIKit

class FoodFilterCollectionViewCell: UICollectionViewCell
{
    
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    var toggleSelectAction = {}
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    @IBAction func onSelectButtonTapped(_ sender: Any)
    {
        toggleSelectAction()
    }
    /*
    func config(with model: SelectableCellViewModel,isGreen: Bool = false)
    {
        if model.isSelected{
            if isGreen
            {
                selectButton.setImage(UIImage.init(named:"Checkbox_green_selected"), for: .normal)
            }
            else
            {
                selectButton.setImage(UIImage.init(named:"Checkbox_beige_selected"), for: .normal)
            }
        }
        else
        {
            if isGreen
            {
                selectButton.setImage(UIImage.init(named:"Checkbox_green_unselected"), for: .normal)
            }
            else
            {
                selectButton.setImage(UIImage.init(named:"Checkbox_beige_unselected"), for: .normal)
            }
        }
        titleLabel.text = model.title
        titleLabel.numberOfLines = 2
    }*/
}
