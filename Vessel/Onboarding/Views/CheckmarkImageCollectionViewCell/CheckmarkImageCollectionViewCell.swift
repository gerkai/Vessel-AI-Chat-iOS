//
//  CheckmarkImageCollectionViewCell.swift
//  vessel-ios
//
//  Created by Carson Whitsett on 7/10/22.
//  Copyright © 2022 Vessel Health Inc. All rights reserved.
//

import UIKit

protocol CheckmarkImageCollectionViewCellDelegate: AnyObject
{
    func checkButtonTapped(id: Int)
    func isChecked(forID id: Int) -> Bool //returns true if checked, false if not.
}

class CheckmarkImageCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    weak var delegate: CheckmarkImageCollectionViewCellDelegate?
    var originalColor: UIColor!
    var type: ItemPreferencesType!
    
    var isChecked = false
    
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
    
    @IBAction func onTapped()
    {
        delegate?.checkButtonTapped(id: tag)
    }
}
