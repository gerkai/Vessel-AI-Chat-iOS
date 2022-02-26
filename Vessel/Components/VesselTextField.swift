//
//  VesselTextField.swift
//  vessel-ios
//
//  Created by Mark Tholking on 3/11/20.
//  Copyright © 2020 Vessel Health Inc. All rights reserved.
//

import UIKit

class VesselTextField: UITextField
{
    let LABEL_FONT_SIZE = 16.0
    private static let cornerRadius: CGFloat = 22.0
    private var blurColor: UIColor = .white

    override func awakeFromNib()
    {
        super.awakeFromNib()
        font = UIFont(name: "NoeText-Regular", size: LABEL_FONT_SIZE)
        textColor = UIColor.darkText
        addPadding(.both(16))
        layer.cornerRadius = VesselTextField.cornerRadius
    }
    
    @IBInspectable
    var borderColor: UIColor?
    {
        get
        {
            let color = UIColor(cgColor: layer.borderColor!)
            return color
        }
        set
        {
            layer.borderColor = newValue?.cgColor
            
            if layer.borderColor == UIColor.clear.cgColor
            {
                layer.borderWidth = 0
            }
            else
            {
                layer.borderWidth = 2
            }
        }
    }
    
    func showInvalidState()
    {
        borderColor = UIColor(red: 243/255, green: 167/255, blue: 165/255, alpha: 1)
        shake()
        becomeFirstResponder()
    }
    
    func resetState()
    {
        borderColor = UIColor.clear
    }

}
