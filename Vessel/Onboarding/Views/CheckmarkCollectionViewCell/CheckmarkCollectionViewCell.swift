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
    var type: ItemPreferencesType!
    
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
                            self.rootView.backgroundColor = UIColor.white
                            self.checkImage.image = UIImage.init(named: "Checkbox_green_selected")
                        }
                        else
                        {
                            self.rootView.backgroundColor = self.originalColor
                            self.checkImage.image = UIImage.init(named: "Checkbox_green_unselected")
                        }
                    }
                    completion:
                    { _ in
                    }
                }
            }
        }
    }
    
    func setup(name: String, id: Int, delegate: CheckmarkCollectionViewCellDelegate, isChecked: Bool, type: ItemPreferencesType)
    {
        titleLabel.text = name
        //we'll use the tag to hold the diet/allergy/goal ID
        tag = id
        self.delegate = delegate
        self.isChecked = isChecked
        self.type = type
    }
    
    @IBAction func onTapped()
    {
        delegate?.checkButtonTapped(id: tag)
    }
}
