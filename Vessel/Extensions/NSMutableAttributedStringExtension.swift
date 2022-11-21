//
//  NSMutableAttributedStringExtension.swift
//  Vessel
//
//  Created by Carson Whitsett on 11/21/22.
//

import UIKit

extension NSMutableAttributedString
{
    func underline(term: String)
    {
        guard let underlineRange = string.range(of: term) else
        {
            return
        }
        let startPosition = string.distance(from: term.startIndex, to: underlineRange.lowerBound)
        let nsrange = NSRange(location: startPosition, length: term.count)

        addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: nsrange)
    }
}
