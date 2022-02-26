//
//  UITextFieldExtensions.swift
//  vessel-ios
//
//  Created by Mark Tholking on 3/11/20.
//  Copyright © 2020 Vessel Health Inc. All rights reserved.
//

import UIKit

extension UITextField
{
    
    enum PaddingSide
    {
        case left(CGFloat)
        case right(CGFloat)
        case both(CGFloat)
    }
    
    func addPadding(_ padding: PaddingSide)
    {
        
        self.leftViewMode = .always
        self.layer.masksToBounds = true
        
        switch padding
        {
            case .left(let spacing):
                let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
                self.leftView = paddingView
                self.rightViewMode = .always
            case .right(let spacing):
                let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
                self.rightView = paddingView
                self.rightViewMode = .always
            case .both(let spacing):
                let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
                // left
                self.leftView = paddingView
                self.leftViewMode = .always
                // right
                self.rightView = paddingView
                self.rightViewMode = .always
        }
    }
    
    func setInputViewDatePicker(target: Any, selector: Selector, minDate: Date? = nil, maxDate: Date? = nil, initialDate: Date? = nil)
    {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .date
        if initialDate != nil
        {
            datePicker.setDate(initialDate!, animated: false)
        }
        if minDate != nil
        {
            datePicker.minimumDate = minDate!
        }
        if maxDate != nil
        {
            datePicker.maximumDate = maxDate!
        }
        if #available(iOS 13.4, *)
        {
            datePicker.preferredDatePickerStyle = .wheels
        }
        self.inputView = datePicker
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel))
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancel, flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
    
    @objc func tapCancel()
    {
        self.resignFirstResponder()
    }
}
