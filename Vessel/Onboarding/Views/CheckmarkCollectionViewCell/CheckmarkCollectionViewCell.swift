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
    func checkButtonTapped(id: Int)
    func isChecked(forID id: Int) -> Bool //returns true if checked, false if not.
}

class CheckmarkCollectionViewCell: UICollectionViewCell
{
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var checkImage: UIImageView!
    @IBOutlet private weak var rootView: UIView!
    private weak var delegate: CheckmarkCollectionViewCellDelegate?
    private var originalColor: UIColor!
    
    private var isChecked = false
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        originalColor = rootView.backgroundColor
        NotificationCenter.default.addObserver(self, selector: #selector(updateCheckmarks), name: .updateCheckmarks, object: nil)
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func updateCheckmarks()
    {
        if let shouldBeChecked = delegate?.isChecked(forID: tag)
        {
            if isChecked != shouldBeChecked
            {
                isChecked = shouldBeChecked
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
                            self.select()
                        }
                        else
                        {
                            self.unselect()
                        }
                    }
                    completion:
                    { _ in
                    }
                }
            }
        }
    }
    
    func select()
    {
        self.rootView.backgroundColor = UIColor.white
        self.checkImage.image = UIImage.init(named: "Checkbox_green_selected")
    }
    
    func unselect()
    {
        self.rootView.backgroundColor = self.originalColor
        self.checkImage.image = UIImage.init(named: "Checkbox_green_unselected")
    }
    
    func setup(name: String, id: Int, delegate: CheckmarkCollectionViewCellDelegate, isChecked: Bool)
    {
        titleLabel.text = name
        //we'll use the tag to hold the diet/allergy/goal ID
        tag = id
        self.delegate = delegate
        self.isChecked = isChecked
        if isChecked == true
        {
            select()
        }
        else
        {
            unselect()
        }
    }
    
    @IBAction func onTapped()
    {
        delegate?.checkButtonTapped(id: tag)
    }
}
