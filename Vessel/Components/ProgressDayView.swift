//
//  ProgressDayView.swift
//  Vessel
//
//  Created by Nicolas Medina on 12/15/22.
//

import UIKit

protocol ProgressDayViewDelegate: AnyObject
{
    func onProgressDayTapped(date: String)
}

class ProgressDayView: UIView
{
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var backgroundBorderView: UIView!
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var dotView: UIView!
    
    private var progress: Double = 0
    private var progressLyr: CAShapeLayer?
    private var pathDrawn = false
    private var dateString = ""
    private weak var delegate: ProgressDayViewDelegate?
    
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
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onViewTapped)))
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        contentView.layoutSubviews()
        makeBorderPath(progress: progress)
    }
    
    func setup(dateString: String, progress: Double, isSelectedDay: Bool, delegate: ProgressDayViewDelegate?)
    {
        self.dateString = dateString
        self.delegate = delegate
        self.progress = progress
        guard let date = Date.serverDateFormatter.date(from: dateString) else { return }
        backgroundView.layer.cornerRadius = backgroundBorderView.frame.width * 0.30
        backgroundView.layer.masksToBounds = true

        dotView.isHidden = !isSelectedDay
        dayLabel.text = Date.dayInitialFormatter.string(from: date)
        backgroundView.backgroundColor = progress == 1.0 ? .black : UIColor.backgroundGray
        dayLabel.textColor = progress == 1.0 ? .white : .black
        makeBorderPath(progress: progress)
    }
    
    func makeBorderPath(progress: Double)
    {
        if let progressLyr = self.progressLyr
        {
            progressLyr.removeFromSuperlayer()
        }
        progressLyr = CAShapeLayer()

        let path = UIBezierPath(roundedRect: backgroundBorderView.bounds,
                                cornerRadius: backgroundBorderView.bounds.width * 0.32)
        progressLyr?.path = path.cgPath
        progressLyr?.fillColor = UIColor.clear.cgColor
        progressLyr?.strokeColor = UIColor.black.cgColor
        progressLyr?.lineWidth = 1.0
        backgroundBorderView.layer.addSublayer(progressLyr!)
        progressLyr?.strokeEnd = CGFloat(progress)
    }
    
    @objc
    func onViewTapped()
    {
        delegate?.onProgressDayTapped(date: self.dateString)
    }
}
