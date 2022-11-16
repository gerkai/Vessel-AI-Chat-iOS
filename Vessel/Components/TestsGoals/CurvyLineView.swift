//
//  CurvyLineView.swift
//  Vessel
//
//  Created by Carson Whitsett on 9/27/22.
//

import UIKit

struct CurvyLine
{
    let startPoint: CGPoint
    let endPoint: CGPoint
    let intensity: CGFloat
    let offset: CGFloat
}

protocol CurvyLineViewDataSource
{
    func curvyLineViewNumCurvyLines() -> Int
    func curvyLineViewData(forIndex index: Int) -> (left: CGPoint, right: CGPoint)
}

class CurvyLineView: UIView
{
    let pointRadius = 8.0
    var Lines: [CurvyLine] = []
    var lineLayers = [CAShapeLayer]()
    var animated = false
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        self.layer.sublayers?.forEach(
        { (layer: CALayer) -> () in
            layer.removeFromSuperlayer()
        })
        lineLayers.removeAll()
        
        if animated
        {
            drawSmoothLines()
            animateLayers()
        }
    }
    
    override func draw(_ rect: CGRect)
    {
        if animated == false
        {
            self.layer.sublayers?.forEach(
            { (layer: CALayer) -> () in
                layer.removeFromSuperlayer()
            })
            lineLayers.removeAll()
            for line in Lines
            {
                let path = UIBezierPath()
                path.lineWidth = 1.5
                if line.startPoint.x < line.endPoint.x
                {
                    let cp1 = CGPoint(x: line.endPoint.x - line.intensity + line.offset, y: line.endPoint.y)
                    let cp2 = CGPoint(x: line.startPoint.x + line.intensity + line.offset, y: line.startPoint.y)
                    path.move(to: line.startPoint)
                    path.addCurve(to: line.endPoint, controlPoint1: cp2, controlPoint2: cp1)
                }
                else
                {
                    let cp1 = CGPoint(x: line.endPoint.x + line.intensity + line.offset, y: line.endPoint.y)
                    let cp2 = CGPoint(x: line.startPoint.x - line.intensity + line.offset, y: line.startPoint.y)
                    path.move(to: line.startPoint)
                    path.addCurve(to: line.endPoint, controlPoint1: cp2, controlPoint2: cp1)
                }
                let color = UIColor(hex: "B0D2A8") //green
                color.setStroke()
                path.stroke()
            }
        }
    }
    
    func drawSmoothLines()
    {
        //draw chart line
        let color = UIColor(hex: "B0D2A8") //green
        
        for line in Lines
        {
            let path = UIBezierPath()
            path.lineWidth = 1.5
            if line.startPoint.x < line.endPoint.x
            {
                let cp1 = CGPoint(x: line.endPoint.x - line.intensity + line.offset, y: line.endPoint.y)
                let cp2 = CGPoint(x: line.startPoint.x + line.intensity + line.offset, y: line.startPoint.y)
                path.move(to: line.startPoint)
                path.addCurve(to: line.endPoint, controlPoint1: cp2, controlPoint2: cp1)
            }
            else
            {
                let cp1 = CGPoint(x: line.endPoint.x + line.intensity + line.offset, y: line.endPoint.y)
                let cp2 = CGPoint(x: line.startPoint.x - line.intensity + line.offset, y: line.startPoint.y)
                path.move(to: line.startPoint)
                path.addCurve(to: line.endPoint, controlPoint1: cp2, controlPoint2: cp1)
            }
            let lineLayer = CAShapeLayer()
            lineLayer.path = path.cgPath
            lineLayer.fillColor = UIColor.clear.cgColor
            lineLayer.strokeColor = color.cgColor
            
            self.layer.addSublayer(lineLayer)
            lineLayers.append(lineLayer)
           
            lineLayer.strokeEnd = 0
        }
    }
    
    func animateLayers()
    {
        let strokeAnimationKey = "StrokeAnimationKey"
        for lineLayer in lineLayers
        {
            let growAnimation = CABasicAnimation(keyPath: "strokeEnd")
            growAnimation.toValue = 1
 
            growAnimation.duration = 0.4

            growAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            growAnimation.fillMode = CAMediaTimingFillMode.forwards
            growAnimation.isRemovedOnCompletion = false
            lineLayer.add(growAnimation, forKey: strokeAnimationKey)
        }
    }
    
    func drawPoint(point: CGPoint, color: UIColor, radius: CGFloat)
    {
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: point.x - radius, y: point.y - radius, width: radius * 2, height: radius * 2))
        color.setFill()
        ovalPath.fill()
    }
    
    func addCurvyLine(line: CurvyLine)
    {
        Lines.append(line)
        setNeedsDisplay()
    }
    
    func clearCurvyLines()
    {
        Lines.removeAll()
        setNeedsDisplay()
    }
}
