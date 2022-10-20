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
        return count > 0 && self.isLettersOnly
    }
    
    func isValidPassword() -> Bool
    {
        count >= Constants.MinimumPasswordLength
    }
    
    var isLettersOnly: Bool
    {
        return !isEmpty && range(of: "[^a-zA-Z]", options: .regularExpression) == nil
    }

    var firstUppercased: String
    {
        prefix(1).uppercased() + dropFirst()
    }
    
    func makeAttributedString() -> NSMutableAttributedString
    {
        var attrStr = NSMutableAttributedString()
        let md = SwiftyMarkdown(string: self)
        if let attributedString = md.attributedString() as? NSMutableAttributedString
        {
            attrStr = attributedString
        }
        return attrStr
    }
}
