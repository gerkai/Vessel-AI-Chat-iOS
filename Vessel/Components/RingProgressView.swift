//
//  RingProgressView.swift
//  Vessel
//
//  Created by v.martin.peshevski on 15.9.23.
//

import UIKit

class RingProgressView: UIView
{
    fileprivate var progressLayer = CAShapeLayer()
    fileprivate var trackLayer = CAShapeLayer()
    fileprivate var didConfigureLabel = false
    fileprivate var filled: Bool

    fileprivate let lineWidth: CGFloat?

    var timeToFill = 3.00

    var progressColor = UIColor.white
    {
        didSet
        {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }

    var trackColor = UIColor.white
    {
        didSet
        {
            trackLayer.strokeColor = trackColor.cgColor
        }
    }

    var progress: Float
    {
        didSet
        {
            var pathMoved = progress - oldValue
            if pathMoved < 0
            {
                pathMoved = 0 - pathMoved
            }
            setProgress(duration: timeToFill * Double(pathMoved), to: progress)
        }
    }

    fileprivate func createProgressView(width: Double, height: Double, cornerRadius: CGFloat)
    {
        self.backgroundColor = .clear
        self.layer.cornerRadius = cornerRadius
        let circularPath: UIBezierPath = UIBezierPath(roundedRect: CGRect(x: -3, y: -3, width: width, height: height), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: cornerRadius, height: 0.0))
        trackLayer.fillColor = UIColor.blue.cgColor
        trackLayer.path = circularPath.cgPath
        trackLayer.fillColor = .none
        trackLayer.strokeColor = trackColor.cgColor
        if filled
        {
            trackLayer.lineCap = .butt
            trackLayer.lineWidth = frame.width
        }
        else
        {
            trackLayer.lineWidth = lineWidth!
        }
        trackLayer.strokeEnd = 1
        layer.addSublayer(trackLayer)
        
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = .none
        progressLayer.strokeColor = progressColor.cgColor
        if filled
        {
            progressLayer.lineCap = .butt
            progressLayer.lineWidth = frame.width
        }
        else
        {
            progressLayer.lineWidth = lineWidth!
        }
        progressLayer.strokeEnd = 0
        layer.addSublayer(progressLayer)
    }

    func trackColorToProgressColor() -> Void
    {
        trackColor = progressColor
        trackColor = UIColor(red: progressColor.cgColor.components![0], green: progressColor.cgColor.components![1], blue: progressColor.cgColor.components![2], alpha: 0.2)
    }

    func setProgress(duration: TimeInterval = 3, to newProgress: Float) -> Void
    {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        
        animation.fromValue = progressLayer.strokeEnd
        animation.toValue = newProgress
        
        progressLayer.strokeEnd = CGFloat(newProgress)
        
        progressLayer.add(animation, forKey: "animationProgress")
    }

    init(frame: CGRect, lineWidth: CGFloat?, cornerRadius: CGFloat)
    {
        progress = 0
        if lineWidth == nil
        {
            self.filled = true
        }
        else
        {
            self.filled = false
        }
        self.lineWidth = lineWidth
        super.init(frame: frame)
        createProgressView(width: frame.width, height: frame.height, cornerRadius: cornerRadius)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
