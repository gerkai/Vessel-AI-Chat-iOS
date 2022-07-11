//
//  UIScrollViewExtension.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/10/22.
//

import UIKit

extension UIScrollView
{

    var isAtTop: Bool
    {
        return contentOffset.y <= verticalOffsetForTop
    }

    var isAtBottom: Bool
    {
        return contentOffset.y >= verticalOffsetForBottom
    }

    var verticalOffsetForTop: CGFloat
    {
        let topInset = contentInset.top
        return -topInset
    }

    var verticalOffsetForBottom: CGFloat
    {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
}
