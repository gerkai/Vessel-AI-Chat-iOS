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
    var Lines: [CurvyLine] = []
    
    override func draw(_ rect: CGRect)
    {
        //draw chart line
        let path = UIBezierPath()
        
        for line in Lines
        {
            let cp1 = CGPoint(x: line.endPoint.x - line.intensity + line.offset, y: line.endPoint.y)
            let cp2 = CGPoint(x: line.startPoint.x + line.intensity + line.offset, y: line.startPoint.y)
            path.move(to: line.startPoint)
            //path.addLine(to: line.endPoint)
            path.addCurve(to: line.endPoint, controlPoint1: cp2, controlPoint2: cp1)
        }
        
        let color = UIColor(hex: "B0D2A8")
        color.setStroke()
        path.lineWidth = 2
        path.stroke()
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
