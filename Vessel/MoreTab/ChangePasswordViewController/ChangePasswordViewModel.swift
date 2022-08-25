//
//  MyAccountViewModel.swift
//  Vessel
//
//  Created by Nicolas Medina on 8/9/22.
//

import Foundation

enum ChangePasswordError: LocalizedError
{
    case invalidOldPassword
    case newPasswordMismatch
    case blankPassword
    case newAndOldPasswordMatch
    case oldPasswordMismatch
    case newPasswordTooShort
    case oldPasswordTooShort
    case unknownError(value: String?)
    
    public var errorDescription: String?
    {
        switch self
        {
        case .invalidOldPassword:
            return NSLocalizedString("The old password does not match.", comment: "")
        case .newPasswordMismatch:
            return NSLocalizedString("The password confirmation does not match.", comment: "")
        case .blankPassword:
            return NSLocalizedString("You must provide old and new passwords.", comment: "")
        case .newAndOldPasswordMatch:
            return NSLocalizedString("New password can't be the same as old password.", comment: "")
        case .oldPasswordMismatch:
            return NSLocalizedString("Your old password is wrong.", comment: "")
        case .newPasswordTooShort:
            return NSLocalizedString("New password is shorter than minimum length 6.", comment: "")
        case .oldPasswordTooShort:
            return NSLocalizedString("Old password is shorter than minimum length 6.", comment: "")
        case .unknownError(let value):
            return NSLocalizedString(value ?? "Unknown error", comment: "")
        }
    }
}

enum ChangePasswordFields
{
    case oldPassword
    case newPassword
    case confirmNewPassword
    
    var placeholder: String
    {
        switch self
        {
        case .oldPassword: return NSLocalizedString("Old Password", comment: "")
        case .newPassword: return NSLocalizedString("New Password", comment: "")
        case .confirmNewPassword: return NSLocalizedString("Confirm New Password", comment: "")
        }
    }
}

class ChangePasswordViewModel
{
    let options: [ChangePasswordFields] =
    [
        .oldPassword,
        .newPassword,
        .confirmNewPassword
    ]
    
    func onChangePasswordSaved(oldPassword: String, newPassword: String, newPasswordConfirmation: String, successCompletion: (() -> Void)?, errorCompletion: ((_ error: Error) -> Void)?)
    {
        if newPassword == newPasswordConfirmation, !oldPassword.isEmpty && !newPassword.isEmpty && !newPasswordConfirmation.isEmpty, newPassword != oldPassword
        {
            Server.shared.changePassword(oldPassword: oldPassword, newPassword: newPassword)
            {
                successCompletion?()
            } onFailure:
            { message in
                if message == "You must provide old and new passwords."
                {
                    errorCompletion?(ChangePasswordError.blankPassword)
                }
                else if message == "Bad current password"
                {
                    errorCompletion?(ChangePasswordError.oldPasswordMismatch)
                }
                else if message == "Shorter than minimum length 6."
                {
                    if newPassword.count < Constants.MinimumPasswordLength
                    {
                        errorCompletion?(ChangePasswordError.newPasswordTooShort)
                    }
                    else if oldPassword.count < Constants.MinimumPasswordLength
                    {
                        errorCompletion?(ChangePasswordError.oldPasswordTooShort)
                    }
                }
                else
                {
                    errorCompletion?(ChangePasswordError.unknownError(value: message))
                }
            }
        }
        else
        {
            if newPassword.isEmpty || oldPassword.isEmpty
            {
                errorCompletion?(ChangePasswordError.blankPassword)
            }
            else if newPassword == oldPassword
            {
                errorCompletion?(ChangePasswordError.newAndOldPasswordMatch)
            }
            else if oldPassword.isEmpty || newPassword.isEmpty || newPasswordConfirmation.isEmpty
            {
                errorCompletion?(ChangePasswordError.blankPassword)
            }
            else
            {
                errorCompletion?(ChangePasswordError.newPasswordMismatch)
            }
        }
    }
}
