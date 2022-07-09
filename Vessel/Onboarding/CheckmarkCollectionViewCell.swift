//
//  CheckmarkCollectionViewCell.swift
//  vessel-ios
//
//  Created by Carson Whitsett on 7/9/22.
//  Copyright © 2022 Vessel Health Inc. All rights reserved.
//

import UIKit

protocol CheckmarkCollectionViewCellDelegate: AnyObject
{
    func checkButtonTapped(forCell cell: UICollectionViewCell, checked: Bool)
    func canCheckMoreButtons() -> Bool
}

class CheckmarkCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    var isChecked = false
    weak var delegate: CheckmarkCollectionViewCellDelegate?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    @IBAction func onTapped(_ sender: UIButton)
    {
        if isChecked == false
        {
            if delegate?.canCheckMoreButtons() == true
            {
                isChecked = true
            }
            else
            {
                return
            }
        }
        else
        {
            isChecked = false
        }
        UIView.animate(withDuration: 0.1)
        {
            self.checkImage.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        completion:
        { _ in
            UIView.animate(withDuration: 0.1)
            {
                self.checkImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                if self.isChecked
                {
                    self.checkImage.image = UIImage.init(named: "Checkbox_green_selected")
                }
                else
                {
                    self.checkImage.image = UIImage.init(named: "Checkbox_green_unselected")
                }
            }
            completion:
            { _ in
                
            }
        }
        self.delegate?.checkButtonTapped(forCell: self, checked: self.isChecked)
    }
}
