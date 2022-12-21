//
//  GamificationCongratulationsView.swift
//  Vessel
//
//  Created by Nicolas Medina on 12/20/22.
//

import UIKit

class GamificationCongratulationsView: UIView
{
    @IBOutlet private weak var daysStackView: UIStackView!
    @IBOutlet private weak var weekStreakLabel: UILabel!
    @IBOutlet private weak var daysCompletedLabel: UILabel!
    @IBOutlet private weak var contentView: UIView!
    
    // MARK: - Initializers
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit()
    {
        let xibName = String(describing: type(of: self))
        
        Bundle.main.loadNibNamed(xibName, owner: self, options: nil)
        contentView.fixInView(self)
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        setup()
    }
    
    private func setup()
    {
        let progress = PlansManager.shared.getLastWeekPlansProgress()
        let dayViews = (daysStackView.arrangedSubviews as? [GamificationCongratulationsDayView] ?? [])
        
        for (index, dateString) in progress.keys.sorted(by: { $0 < $1 }).enumerated()
        {
            if let date = Date.serverDateFormatter.date(from: dateString),
               let dayView = dayViews[safe: index]
            {
                dayView.setup(text: Date.dayInitialFormatter.string(from: date), complete: progress[dateString] == 1.0)
            }
        }
        
        weekStreakLabel.text = "\(PlansManager.shared.calculateWeekStreak())"
        daysCompletedLabel.text = "\(PlansManager.shared.allCompletedDaysCount())"
    }
}
