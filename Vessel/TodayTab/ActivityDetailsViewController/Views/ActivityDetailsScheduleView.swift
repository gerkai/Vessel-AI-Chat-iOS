//
//  ActivityDetailsScheduleView.swift
//  Vessel
//
//  Created by Nicolas Medina on 2/21/23.
//

import UIKit

class ActivityDetailsScheduleView: UIView
{
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
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
        setup()
    }
    
    func setup(dayText: String = "", timeText: String = "")
    {
        dayLabel.text = dayText
        timeLabel.text = timeText.convertTo12HourFormat()
    }
}
