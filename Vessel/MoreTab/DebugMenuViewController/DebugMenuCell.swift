//
//  DebugMenuCell.swift
//  Vessel
//
//  Created by Nicolas Medina on 8/23/22.
//

import UIKit

protocol DebugMenuCellDelegate: AnyObject
{
    func onToggle(_ value: Bool, tag: Int, textFieldValue: String?)
}

class DebugMenuCell: UITableViewCell
{
    // MARK: - View
    @IBOutlet weak var textField: UITextField!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var switchToggle: UISwitch!
    private var delegate: DebugMenuCellDelegate?
    
    // MARK: - Methods
    func setup(title: String, turnedOn: Bool, showTextField: Bool = false, delegate: DebugMenuCellDelegate)
    {
        titleLabel.text = title
        switchToggle.isOn = turnedOn
        textField.isHidden = !showTextField
        textField.delegate = self
        self.delegate = delegate
    }
    
    // MARK: - Actions
    @IBAction func onSwitchToggle()
    {
        delegate?.onToggle(switchToggle.isOn, tag: tag, textFieldValue: textField.text)
    }
}

extension DebugMenuCell: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}
