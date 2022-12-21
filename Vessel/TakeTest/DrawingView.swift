//
//  DrawingView.swift
//  Scanner
//
//  Created by Carson Whitsett on 7/15/22.
//
//
// camera is 1920px x 1080px but we rotate 90 degrees (1080px x 1920px)
// Just some numbers from actual devices to reference during development
// Device           Camera PX       Frame PX        FrameW / CamW       FrameH / CamH
//12ProMax stock    1080, 1920      1284, 2778      1.1888888889        1.446875
//12ProMax .photo   3024, 4032      1284, 2778      0.4246031746        0.6889880952
//iPhoneSE  stock   1080, 1920      750, 1334       0.6944444444        0.6947916667
//iPhoneSE .photo   3024, 4032      750, 1334       0.2447089947        0.3308531746

// Device           Camera PT       Frame PT        FrameW / CamW
//12ProMax stock    360, 640        428, 926        1.1888888889        1.446875
//12ProMax .photo   1008, 1344      428, 926        0.4246031746        0.6889880952
//iPhoneSE  stock   360, 640        375, 667        1.0416666667        1.0421875
//iPhoneSE .photo   1008, 1344      375, 667        0.3720238095        0.4962797619

//  width difference:  428 - 360 = 392  (/2 = 196)
//  height difference: 926 - 640 = 296  (/2 = 148)

//  determine aspect fit scale factor
//  1284 / 1080 = 1.18889
//  2778 / 1920 = 1.446875
//  scaled camera image is: 1284 x 2282.66667

// Y offset = (frameHeight - (frameW / CamW) * CamHeight) / 2

// Card width = 1.554"
// Card height = 5.335"
// Card aspect ratio = 3.43 : 1

import UIKit

protocol DrawingViewDelegate
{
    //isCloseEnough = -1 if too far away or 1 if too near. 0 if just right.
    //isOnScreen = true if all four fiducials are on screen
    func drawingStatus(isOnScreen: Bool, isCloseEnough: Int, upsideDown: Bool)
}

class DrawingView: UIView
{
    var qrBox: [CGPoint]?
    var converted: [CGPoint] = []
    var cameraSize = CGSize()
    var delegate: DrawingViewDelegate?
    let numFiducialsToAverage = 10
    var arrayG: [CGPoint] = []
    var arrayH: [CGPoint] = []
    var validArea: CGRect = CGRect()
    var showDebugDrawing = false
    let debugRelaxScanningDistance = UserDefaults.standard.bool(forKey: Constants.KEY_RELAXED_SCANNING_DISTANCE)
    override func draw(_ rect: CGRect)
    {
        UIGraphicsGetCurrentContext()
        if let context = UIGraphicsGetCurrentContext()
        {
            context.setLineWidth(4.0)
            
            if let box = qrBox
            {
                let cWidth = cameraSize.width / UIScreen.main.scale
                let cHeight = cameraSize.height / UIScreen.main.scale
                
                let hScale = frame.height / cHeight
                let scaledCamWidth = cWidth * hScale
                let camXOffset = (frame.width - scaledCamWidth) / 2
                
                /* for video gravity turned off
                let pointA = CGPoint(x: frame.width - box[0].y * frame.width, y: camYOffset + box[0].x * scaledCamHeight)
                let pointD = CGPoint(x: frame.width - box[1].y * frame.width, y: camYOffset + box[1].x * scaledCamHeight)
                let pointC = CGPoint(x: frame.width - box[2].y * frame.width, y: camYOffset + box[2].x * scaledCamHeight)
                let pointB = CGPoint(x: frame.width - box[3].y * frame.width, y: camYOffset + box[3].x * scaledCamHeight)
                */
                
                let pointA = CGPoint(x: -camXOffset + frame.width - box[0].y * scaledCamWidth, y: box[0].x * frame.height)
                let pointD = CGPoint(x: -camXOffset + frame.width - box[1].y * scaledCamWidth, y: box[1].x * frame.height)
                let pointC = CGPoint(x: -camXOffset + frame.width - box[2].y * scaledCamWidth, y: box[2].x * frame.height)
                let pointB = CGPoint(x: -camXOffset + frame.width - box[3].y * scaledCamWidth, y: box[3].x * frame.height)
                
                let lengthAB = length(pointA, pointB)
                let lengthCD = length(pointC, pointD)
                //if camera is dead-on then the lengths of the QR top line and QR bottom line will be equal
                //otherwise, there will be some ratio depending on perspective (the length of AB gets shorter with respect
                //to the length of CD if AB is further away from the camera)
                let perspectiveRatio = lengthCD / lengthAB
                //amplify any deviation to better approximate lower fiducial locations
                let fudge = (perspectiveRatio - 1.0) * 5 //value of 5 was chosen based on empirical testing.
                //print("Ratio: \(perspectiveRatio)")
                
                //print("Tilt: \(tiltRatio)")
                //card geometry (see Card Geometry Omnigraffle for point names and ratios)
                let ajabRatio = 0.634
                let bkabRatio = ajabRatio
                let adjeRatio = 0.134
                let bckfRatio = adjeRatio
                let fgbcRatio = 6.061
                let ehadRatio = fgbcRatio
                
                //find the four fiducial regions
                let jX = pointA.x - (pointB.x - pointA.x) * ajabRatio
                let jY = pointA.y - (pointB.y - pointA.y) * ajabRatio
                let eX = jX - (pointD.x - pointA.x) * adjeRatio
                let eY = jY - (pointD.y - pointA.y) * adjeRatio
                let pointE = CGPoint(x: eX, y: eY)
                
                let kX = pointB.x + (pointB.x - pointA.x) * bkabRatio
                let kY = pointB.y + (pointB.y - pointA.y) * bkabRatio
                let fX = kX - (pointC.x - pointB.x) * bckfRatio
                let fY = kY - (pointC.y - pointB.y) * bckfRatio
                let pointF = CGPoint(x: fX, y: fY)
                
                let gX = pointF.x + (pointC.x - pointB.x) * (fgbcRatio * (perspectiveRatio + fudge))
                let gY = pointF.y + (pointC.y - pointB.y) * (fgbcRatio * (perspectiveRatio + fudge))
                let pointG = CGPoint(x: gX, y: gY)
                arrayG.append(pointG)
                if arrayG.count > numFiducialsToAverage
                {
                    arrayG.removeFirst()
                }
                
                let hX = pointE.x + (pointD.x - pointA.x) * (ehadRatio * (perspectiveRatio + fudge))
                let hY = pointE.y + (pointD.y - pointA.y) * (ehadRatio * (perspectiveRatio + fudge))
                let pointH = CGPoint(x: hX, y: hY)
                arrayH.append(pointH)
                if arrayH.count > numFiducialsToAverage
                {
                    arrayH.removeFirst()
                }
                
                //draw box around qr code
                if showDebugDrawing == true
                {
                    context.setStrokeColor(UIColor.yellow.cgColor)
                    context.move(to: pointA)
                    context.addLine(to: pointD)
                    context.addLine(to: pointC)
                    context.addLine(to: pointB)
                    context.strokePath()
                    //top of qr code is red
                    context.setStrokeColor(UIColor.red.cgColor)
                    context.move(to: pointB)
                    context.addLine(to: pointA)
                    context.strokePath()
                }
                
                //draw fiducials
                context.setStrokeColor(UIColor.green.cgColor)
                var error = 0
                error = error + calculateFiducialAtPoint(pointE, context: context, validFrame: validArea, drawToo: showDebugDrawing)
                error = error + calculateFiducialAtPoint(pointF, context: context, validFrame: validArea, drawToo: showDebugDrawing)
                error = error + calculateFiducialAtPoint(averagePoint(points: arrayG), context: context, validFrame: validArea, drawToo: showDebugDrawing)
                error = error + calculateFiducialAtPoint(averagePoint(points: arrayH), context: context, validFrame: validArea, drawToo: showDebugDrawing)
                if showDebugDrawing
                {
                    context.strokePath()
                }
                
                var isOnScreen = true
                var isCloseEnough = 0
                
                //if any fiducials are outside of valid card area set isOnScreen to false
                if error != 0
                {
                    isOnScreen = false
                }
                
                //if area of fiducial box is significantly less than area of cameraView set isCloseEnough to false
                let widthEF = length(pointE, pointF)
                
                //uncomment below to determine too-close / too-far values
                //print("Distance: \(widthEF / validArea.size.width)")
                
                if widthEF < validArea.size.width * 0.60 //subjective (use print statement above to set)
                {
                    //too far away
                    if debugRelaxScanningDistance == true
                    {
                        isCloseEnough = 0
                    }
                    else
                    {
                        isCloseEnough = -1
                    }
                }
                else if widthEF > validArea.size.width * 0.91 //subjective  (use print statement above to set)
                {
                    //too cloase
                    if debugRelaxScanningDistance == true
                    {
                        isCloseEnough = 0
                    }
                    else
                    {
                        isCloseEnough = 1
                    }
                }
                else
                {
                    isCloseEnough = 0
                }
                
                //report if card is upside down
                var upsideDown = false
                if pointA.y > pointD.y && pointB.y > pointC.y
                {
                    upsideDown = true
                }
                
                //draw outline of valid scan area
                if isOnScreen && isCloseEnough == 0 && upsideDown == false
                {
                    context.setStrokeColor(UIColor.green.cgColor)
                }
                else
                {
                    context.setStrokeColor(UIColor.red.cgColor)
                }
                context.addRect(validArea)
                context.strokePath()
                
                delegate?.drawingStatus(isOnScreen: isOnScreen, isCloseEnough: isCloseEnough, upsideDown: upsideDown)
            }
            else
            {
                context.clear(bounds)
                context.setFillColor(backgroundColor?.cgColor ?? UIColor.clear.cgColor)
                context.fill(bounds)
            }
        }
        UIGraphicsEndImageContext()
    }
    
    func averagePoint(points: [CGPoint]) -> CGPoint
    {
        var x = 0.0
        var y = 0.0
        if points.count != 0
        {
            for point in points
            {
                x += point.x
                y += point.y
            }
            x /= Double(points.count)
            y /= Double(points.count)
        }
        return CGPoint(x: x, y: y)
    }
    
    func calculateFiducialAtPoint(_ point: CGPoint, context: CGContext, validFrame: CGRect, drawToo: Bool) -> Int
    {
        //returns 0 if all four fiducials are on screen otherwise returns number of fiducials off screen
        let fiducialSize = 30.0
        
        let pointERect = CGRect(x: point.x - fiducialSize / 2, y: point.y - fiducialSize / 2, width: fiducialSize, height: fiducialSize)
        if drawToo
        {
            context.addRect(pointERect)
        }
        var error = 0
        if point.x < validFrame.origin.x
        {
            error += 1
        }
        if point.x > validFrame.origin.x + validFrame.width
        {
            error += 1
        }
        if point.y < validFrame.origin.y
        {
            error += 1
        }
        if point.y > validFrame.origin.y + validFrame.height
        {
            error += 1
        }
        return error
    }
    
    func length(_ pointA: CGPoint, _ pointB: CGPoint) -> Double
    {
        let x = pointB.x - pointA.x
        let y = pointB.y - pointA.y
        return sqrt((x * x) + (y * y))
    }
    
    func qrBoxPercentages() -> [CGPoint]
    {
        if let box = qrBox
        {
            //x = 1.0 - qrBox[n].y
            //y = qrBox[n].x
            return [CGPoint(x: 1.0 - box[0].y, y: box[0].x), CGPoint(x: 1.0 - box[1].y, y: box[1].x), CGPoint(x: 1.0 - box[2].y, y: box[2].x), CGPoint(x: 1.0 - box[3].y, y: box[3].x)]
        }
        else
        {
            return [CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0)]
        }
    }
}
