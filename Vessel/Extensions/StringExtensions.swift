//
//  StringExtensions.swift
//  Vessel
//
//  Created by Carson Whitsett on 2/26/22.
//

import Foundation

extension String
{
    func isValidEmail() -> Bool
    {
        //make sure e-mail address has an @ and a . in it. Also should contain valid alphanumeric characters / symbols
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func isValidName() -> Bool
    {
        if self.count > 0 && self.isLettersOnly
        {
            return true
        }
        return false
    }
    
    func isValidPassword() -> Bool
    {
        if self.count > Constants.MinimumPasswordLength
        {
            return true
        }
        return false
    }
    
    var isLettersOnly: Bool
    {
        return !isEmpty && range(of: "[^a-zA-Z]", options: .regularExpression) == nil
    }

    var firstUppercased: String
    {
        prefix(1).uppercased() + dropFirst()
    }
    
}
