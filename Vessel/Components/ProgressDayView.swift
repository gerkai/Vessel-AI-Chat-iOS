//
//  ProgressDayView.swift
//  Vessel
//
//  Created by Nicolas Medina on 12/15/22.
//

import UIKit

class ProgressDayView: UIView
{
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var currentDayPointLabel: UILabel!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var backgroundBorderView: UIView!
    @IBOutlet private weak var backgroundView: UIView!
    
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
        
//        backgroundBorderView.layer.borderWidth = 1
//        backgroundBorderView.layer.borderColor = UIColor.black.cgColor
    }
    
    func setup(dateString: String, progress: Double)
    {
        guard let date = Date.serverDateFormatter.date(from: dateString) else { return }
        makeBorderPath(progress: progress)
        currentDayPointLabel.isHidden = !Date.isSameDay(date1: date, date2: Date())
        dayLabel.text = Date.dayInitialFormatter.string(from: date)
        backgroundView.backgroundColor = progress == 1.0 ? .black : UIColor.backgroundGray
//        backgroundView.backgroundColor = .clear
        dayLabel.textColor = progress == 1.0 ? .white : .black
    }
    
    func makeBorderPath(progress: Double)
    {
        let progressLyr = CAShapeLayer()

        let path = UIBezierPath(roundedRect: backgroundBorderView.bounds, cornerRadius: 13.0)
        progressLyr.path = path.cgPath
        progressLyr.fillColor = UIColor.clear.cgColor
        progressLyr.strokeColor = UIColor.black.cgColor
        progressLyr.lineWidth = 1.0
        backgroundBorderView.layer.addSublayer(progressLyr)
        progressLyr.strokeEnd = CGFloat(progress)
    }
}
