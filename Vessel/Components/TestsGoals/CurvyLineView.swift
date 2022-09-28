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
    
    override func draw(_ rect: CGRect)
    {
        //draw chart line
        let path = UIBezierPath()
        
        for line in Lines
        {
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
        }
        let color = UIColor(hex: "B0D2A8") //green
        color.setStroke()
        path.lineWidth = 1.5
        path.stroke()
        
        /* uncomment to draw dots used for debugging
        if Lines.count != 0
        {
            drawPoint(point: Lines[0].startPoint, color: .gray, radius: pointRadius)
            drawPoint(point: Lines[0].endPoint, color: .green, radius: pointRadius)
            //drawPoint(point: cp1, color: .red, radius: pointRadius)
            //drawPoint(point: cp2, color: .blue, radius: pointRadius)
        }*/
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
