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
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
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
}
