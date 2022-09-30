//
//  TodayHeaderTableViewCell.swift
//  Vessel
//
//  Created by Nicolas Medina on 9/26/22.
//

import UIKit

class TodayHeaderTableViewCell: UITableViewCell
{
    // MARK: - UI
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!

    // MARK: - Methods
    func setup(name: String, goals: String)
    {
        titleLabel.text = NSLocalizedString("Hi \(name.capitalized)!", comment: "Greetings message")
        subtitleLabel.text = NSLocalizedString("Today's plan for \(goals).", comment: "Subtitle message")
    }
}
