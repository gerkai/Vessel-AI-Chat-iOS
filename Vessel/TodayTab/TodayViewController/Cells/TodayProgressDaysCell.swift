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
    private var selectedDay: String = ""
    private var progress: [String: Double] = [:]
    private weak var delegate: ProgressDayViewDelegate?
    private var setup = false
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        contentView.layoutSubviews()
        
        if !setup
        {
//            setup = true
            let dates = progress.keys.sorted(by: { $0 < $1 })
            for (index, view) in (stackView.arrangedSubviews as? [ProgressDayView] ?? []).enumerated()
            {
                let date = dates[index]
                view.setup(dateString: date, progress: progress[date] ?? 0, isSelectedDay: selectedDay == date, delegate: delegate)
            }
        }
    }
    
    func setup(progress: [String: Double], selectedDay: String, delegate: ProgressDayViewDelegate?)
    {
        self.selectedDay = selectedDay
        self.progress = progress
        self.delegate = delegate
    }
}
