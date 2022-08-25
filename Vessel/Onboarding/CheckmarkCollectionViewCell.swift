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
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var checkImage: UIImageView!
    @IBOutlet private weak var rootView: UIView!
    private weak var delegate: CheckmarkCollectionViewCellDelegate?
    private var originalColor: UIColor!
    
    private var isChecked = false
    {
        didSet
        {
            if isChecked
            {
                self.checkImage.image = UIImage.init(named: "Checkbox_green_selected")
                self.rootView.backgroundColor = UIColor.white
            }
            else
            {
                self.checkImage.image = UIImage.init(named: "Checkbox_green_unselected")
                self.rootView.backgroundColor = self.originalColor
            }
        }
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        originalColor = rootView.backgroundColor
    }
    
    func setup(name: String, id: Int, delegate: CheckmarkCollectionViewCellDelegate, isChecked: Bool)
    {
        titleLabel.text = name
        //we'll use the tag to hold the diet/allergy/goal ID
        tag = id
        self.delegate = delegate
        self.isChecked = isChecked
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
                    self.rootView.backgroundColor = UIColor.white
                }
                else
                {
                    self.rootView.backgroundColor = self.originalColor
                }
            }
            completion:
            { _ in
                self.delegate?.checkButtonTapped(forCell: self, checked: self.isChecked)
            }
        }
    }
}
