//
//  UIImageExtensions.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/19/22.
//

import UIKit

extension UIImage
{
    //used for creating UISegmentedControl buttons with both text and image
    static func textEmbeded(image: UIImage, string: String, isImageBeforeText: Bool, segFont: UIFont? = nil) -> UIImage
    {
        let textImageSpacing = 8.0
        //let font = segFont ?? UIFont.systemFont(ofSize: 16)
        let font = segFont ?? UIFont(name: "BananaGrotesk-Semibold", size: 16.0)!
        let expectedTextSize = (string as NSString).size(withAttributes: [.font: font])
        let width = expectedTextSize.width + image.size.width + textImageSpacing
        let height = max(expectedTextSize.height, image.size.height)
        let size = CGSize(width: width, height: height)

        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image
        { context in
            let fontTopPosition: CGFloat = (height - expectedTextSize.height) / 2
            let textOrigin: CGFloat = isImageBeforeText ? image.size.width + textImageSpacing : 0
            let textPoint: CGPoint = CGPoint.init(x: textOrigin, y: fontTopPosition)
            string.draw(at: textPoint, withAttributes: [.font: font])
            let alignment: CGFloat = isImageBeforeText ? 0 : expectedTextSize.width + textImageSpacing
            let rect = CGRect(x: alignment, y: (height - image.size.height) / 2, width: image.size.width, height: image.size.height)
            image.draw(in: rect)
        }
    }
}
