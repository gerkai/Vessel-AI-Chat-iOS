//
//  StringExtensions.swift
//  Vessel
//
//  Created by Carson Whitsett on 2/26/22.
//

import Foundation
import SwiftyMarkdown

extension String
{
    func isValidEmail() -> Bool
    {
        //make sure e-mail address has an @ and a . in it. Also should contain valid alphanumeric characters / symbols
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func isValidName() -> Bool
    {
        return count > 0 && self.isLettersAndSpacesOnly
    }
    
    func isValidPassword() -> Bool
    {
        count >= Constants.MinimumPasswordLength
    }
    
    var isLettersAndSpacesOnly: Bool
    {
        //returns true if string only contains letters (or spaces)
        return !isEmpty && range(of: "[^a-zA-Z ]", options: .regularExpression) == nil
    }

    var firstUppercased: String
    {
        prefix(1).uppercased()
    }
    
    func makeAttributedString(fontName: String? = nil, textColor: UIColor? = nil) -> NSMutableAttributedString
    {
        var attrStr = NSMutableAttributedString()
        let md = SwiftyMarkdown(string: self)
        if let fontName = fontName
        {
            md.setFontNameForAllStyles(with: fontName)
        }
        if let textColor = textColor
        {
            md.setFontColorForAllStyles(with: textColor)
        }
        if let attributedString = md.attributedString() as? NSMutableAttributedString
        {
            attrStr = attributedString
        }
        return attrStr
    }
}

extension String
{
    func convertTo24HourFormat() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.amSymbol = Constants.AM_SYMBOL
        dateFormatter.pmSymbol = Constants.PM_SYMBOL

        guard let date = dateFormatter.date(from: self) else
        {
            return self
        }
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func convertTo12HourFormat() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        guard let date = dateFormatter.date(from: self) else
        {
            return self
        }
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.amSymbol = Constants.AM_SYMBOL
        dateFormatter.pmSymbol = Constants.PM_SYMBOL
        return dateFormatter.string(from: date)
    }
    
    func removeISODateEndingToServerFormat() -> String?
    {
        return String(self.dropLast(16))
    }
}
