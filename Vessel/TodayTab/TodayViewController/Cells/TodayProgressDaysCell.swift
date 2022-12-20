//
//  TodayProgressDaysCell.swift
//  Vessel
//
//  Created by Nicolas Medina on 12/15/22.
//

import UIKit

class TodayProgressDaysCell: UITableViewCell
{
    @IBOutlet private weak var stackView: UIStackView!
    
    func setup(progress: [String: Double])
    {
        let dates = progress.keys.sorted(by: { $0 < $1 })
        for (index, view) in (stackView.arrangedSubviews as? [ProgressDayView] ?? []).enumerated()
        {
            let date = dates[index]
            view.setup(dateString: date, progress: progress[date] ?? 0)
        }
    }
}
