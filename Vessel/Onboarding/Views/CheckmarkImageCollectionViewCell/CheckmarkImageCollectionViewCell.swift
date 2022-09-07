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
    func checkButtonTapped(forCell cell: UICollectionViewCell, checked: Bool)
    func canCheckMoreButtons() -> Bool
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
        NotificationCenter.default.addObserver(self, selector: #selector(onRefreshCheckmarks), name: .updateCheckmarks, object: nil)
    }
    
    @objc func onRefreshCheckmarks()
    {
        if let shouldBeChecked = delegate?.isChecked(forID: tag)
        {
            print("Image Should Be checked: \(tag), \(shouldBeChecked)")
            if isChecked != shouldBeChecked
            {
                onTapped()
            }
        }
    }
    
    @IBAction func onTapped()
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
        self.delegate?.checkButtonTapped(forCell: self, checked: self.isChecked)
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
               // self.delegate?.checkButtonTapped(forCell: self, checked: self.isChecked)
            }
        }
    }
}
