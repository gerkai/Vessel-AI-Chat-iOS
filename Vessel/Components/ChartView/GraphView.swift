//
//  GraphView.swift
//  ChartView
//
//  Created by Carson Whitsett on 9/21/22.
//
//  Caller provides 5 data points (2 before, this point and 2 after) in data[]
//  This will plot the curve from the previous point to this point and from this point to the next point.
//  if isSelected is set to true, tick marks will be displayed and the dot will appear as a larger hollow circle. Otherwise it will be a smaller filled-in dot.
import UIKit

enum GraphSide
{
    case left
    case right
}

class GraphView: UIView
{
    let pointRegionSize = 12.0
    let pointSize = 6.0
    let tickWidth = 4.0
    var drawTickMarks = true
    var reagentID: Int?
    var regionHeight: CGFloat = 0.0
    
    var isSelected = false
    {
        //if isSelected, we'll draw a circle selection dot (and tick marks if drawTickMarks == true). Else draw solid dot and no tick marks
        didSet
        {
            setNeedsDisplay()
        }
    }
    
    var data: [Result]!
    {
        didSet
        {
            setNeedsDisplay()
        }
    }
    
    func coordFor(index: Int) -> CGPoint
    {
        let x = CGFloat(index - 2) * frame.width + (frame.width / 2)
        var y = Constants.CHART_Y_COORDINATE_FOR_BAD_DATA
        
        if let reagentID = reagentID
        {
            //put Y coordinate in center of zone
            
            //get the reagent associated with reagentID
            let reagent = Reagent.fromID(id: reagentID)
            
            //get number of buckets in this reagent
            let numBuckets = reagent.buckets.count
            
            //calculate zone height
            let zoneHeight = frame.height / CGFloat(numBuckets)
            
            //determine which bucket this result falls into
            var result: ReagentResult?
            
            for dataResult in data[index].reagentResults
            {
                if dataResult.id == reagentID
                {
                    result = dataResult
                    break
                }
            }
            if result != nil
            {
                if let index = reagent.getBucketIndex(value: result!.value)
                {
                    y = CGFloat(index) * zoneHeight + (zoneHeight / 2.0)
                }
            }
            
            return CGPoint(x: x, y: y)
        }
        else
        {
            //shrink Y drawable area by pointRegionSize so that we don't clip selected dot
            let range = data[index].wellnessScore * (bounds.height - pointRegionSize)
            let y = bounds.height - pointRegionSize / 2 - range
            return CGPoint(x: x, y: y)
        }
    }
    
    override func draw(_ rect: CGRect)
    {
        //draw chart line
        let path = UIBezierPath()
        if data[0].wellnessScore != -1
        {
            //left side of point
            quadCurvedPath(path, side: .left)
        }
        if data[4].wellnessScore != -1
        {
            //right side of point
            quadCurvedPath(path, side: .right)
        }

        UIColor.black.setStroke()
        path.lineWidth = 2
        path.stroke()
        
        let point = coordFor(index: 2)
        
        UIGraphicsGetCurrentContext()
        if let context = UIGraphicsGetCurrentContext()
        {
            context.setLineWidth(2.0)
            let selectedSize = pointSize * 1.5
            let selectedRegionSize = pointRegionSize * 1.5
            
            //erase region around dot
            context.setBlendMode(.clear)
            
            if isSelected == true
            {
                //selected dot is a little different (stroked instead of filled and bigger)
                context.fillEllipse(in: CGRectMake(point.x - selectedRegionSize / 2, point.y - selectedRegionSize / 2, selectedRegionSize, selectedRegionSize))
                
                //draw the dot
                context.setBlendMode(.normal)
                context.strokeEllipse(in: CGRectMake(point.x - selectedSize / 2, point.y - selectedSize / 2, selectedSize, selectedSize))
            }
            else
            {
                //erase region around dot an draw normal dot
                context.fillEllipse(in: CGRectMake(point.x - pointRegionSize / 2, point.y - pointRegionSize / 2, pointRegionSize, pointRegionSize))
                
                //draw the dot
                context.setBlendMode(.normal)
                context.fillEllipse(in: CGRectMake(point.x - pointSize / 2, point.y - pointSize / 2, pointSize, pointSize))
            }
        
            //draw the tick marks
            if isSelected && drawTickMarks
            {
                let lineWidth = 2.0
                context.setLineWidth(lineWidth)
                context.setStrokeColor(UIColor.black.cgColor)
                context.setFillColor(UIColor.black.cgColor)
                let horizOffset = 6.0 //offset to edge of FrostedView
                let startX = frame.origin.x + frame.width - (horizOffset + tickWidth)
                let endX = frame.origin.x + frame.width - horizOffset
                //shrink by pointRegionSize so that we don't clip the selected dot
                let regionHeight = frame.height - pointRegionSize
                let originY = bounds.origin.y + pointRegionSize / 2
                
                var y = originY + regionHeight * 0.0// + lineWidth / 2.0
                context.move(to: CGPoint(x: startX, y: y))
                context.addLine(to: CGPoint(x: endX, y: y))
                
                y = originY + regionHeight * 0.2
                context.move(to: CGPoint(x: startX, y: y))
                context.addLine(to: CGPoint(x: endX, y: y))
                
                y = originY + regionHeight * 0.4
                context.move(to: CGPoint(x: startX, y: y))
                context.addLine(to: CGPoint(x: endX, y: y))
                
                y = originY + regionHeight * 0.6
                context.move(to: CGPoint(x: startX, y: y))
                context.addLine(to: CGPoint(x: endX, y: y))
                
                y = originY + regionHeight * 0.8
                context.move(to: CGPoint(x: startX, y: y))
                context.addLine(to: CGPoint(x: endX, y: y))
                
                context.strokePath()
            }
        }
    }
    
    func quadCurvedPath(_ path: UIBezierPath, side: GraphSide)
    {
        //default to points for left side
        var p1 = coordFor(index: 0)
        var p2 = coordFor(index: 1)
        var p3 = coordFor(index: 2)
        var p4 = coordFor(index: 3)
        if side == .right
        {
            p1 = coordFor(index: 1)
            p2 = coordFor(index: 2)
            p3 = coordFor(index: 3)
            p4 = coordFor(index: 4)
        }
        
        //if it's a bad data point, don't draw lines to it
        if p2.y == Constants.CHART_Y_COORDINATE_FOR_BAD_DATA || p3.y == Constants.CHART_Y_COORDINATE_FOR_BAD_DATA
        {
            return
        }
        
        let oldCP = antipodalFor(point: controlPointForPoints(p1: p1, p2: p2, next: p3), center: p2)
        let newCP = controlPointForPoints(p1: p2, p2: p3, next: p4)
        path.move(to: p2)
        path.addCurve(to: p3, controlPoint1: oldCP, controlPoint2: newCP)
    }
    
    /// located on the opposite side from the center point
    func antipodalFor(point: CGPoint, center: CGPoint) -> CGPoint
    {
        let p1 = point
        //let center = center
        let newX = 2 * center.x - p1.x
        let diffY = abs(p1.y - center.y)
        let newY = center.y + diffY * (p1.y < center.y ? 1 : -1)

        return CGPoint(x: newX, y: newY)
    }

    /// halfway of two points
    func midPointForPoints(p1: CGPoint, p2: CGPoint) -> CGPoint
    {
        return CGPoint(x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2);
    }

    /// Find controlPoint2 for addCurve
    /// - Parameters:
    ///   - p1: first point of curve
    ///   - p2: second point of curve whose control point we are looking for
    ///   - next: predicted next point which will use antipodal control point for finded
    func controlPointForPoints(p1: CGPoint, p2: CGPoint, next p3: CGPoint) -> CGPoint
    {
        let leftMidPoint  = midPointForPoints(p1: p1, p2: p2)
        let rightMidPoint = midPointForPoints(p1: p2, p2: p3)

        var controlPoint = midPointForPoints(p1: leftMidPoint, p2: antipodalFor(point: rightMidPoint, center: p2))

        if p1.y.between(a: p2.y, b: controlPoint.y)
        {
            controlPoint.y = p1.y
        }
        else if p2.y.between(a: p1.y, b: controlPoint.y)
        {
            controlPoint.y = p2.y
        }

        let imaginContol = antipodalFor(point: controlPoint, center: p2)
        if p2.y.between(a: p3.y, b: imaginContol.y)
        {
            controlPoint.y = p2.y
        }
        if p3.y.between(a: p2.y, b: imaginContol.y)
        {
            let diffY = abs(p2.y - p3.y)
            controlPoint.y = p2.y + diffY * (p3.y < p2.y ? 1 : -1)
        }

        // make lines easier
        controlPoint.x += (p2.x - p1.x) * 0.1

        return controlPoint
    }

    func drawPoint(point: CGPoint, color: UIColor, radius: CGFloat)
    {
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: point.x - radius, y: point.y - radius, width: radius * 2, height: radius * 2))
        color.setFill()
        ovalPath.fill()
    }
}

extension CGFloat
{
    func between(a: CGFloat, b: CGFloat) -> Bool
    {
        return self >= Swift.min(a, b) && self <= Swift.max(a, b)
    }
}
