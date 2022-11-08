//
//  AutoSizedCollectionView.swift
//  Vessel
//
//  Created by Carson Whitsett on 11/7/22.
//  This will size the collectionView to the size of its content. Perfect when embedding a collectionView
//  within a UIScrollView. Just subclass from AutoSizedCollectionView and it will take care of the rest.

import UIKit

class AutoSizedCollectionView: UICollectionView
{
    override var contentSize: CGSize
    {
        didSet
        {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize
    {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
