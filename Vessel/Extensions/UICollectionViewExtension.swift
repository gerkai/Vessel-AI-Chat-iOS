//
//  UICollectionViewExtension.swift
//  vessel-ios
//
//  Created by Mahmoud Fathy on 23/09/2020.
//  Copyright © 2020 Vessel Health Inc. All rights reserved.
//

import UIKit

extension UICollectionView
{
    func register<T: UICollectionViewCell>(_: T.Type)
    {
        register(T.self, forCellWithReuseIdentifier: T.className)
    }
    
    func registerFromNib<T: UICollectionViewCell>(_: T.Type)
    {
        register(T.nib, forCellWithReuseIdentifier: T.className)
    }
    
    func register<T: UICollectionReusableView>(_: T.Type, with kind: String)
    {
        register(T.nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.className)
    }
    
    func dequeueCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T
    {
        return dequeueReusableCell(withReuseIdentifier: T.className, for: indexPath) as! T
    }
    
    func dequeueReusableView<T: UICollectionReusableView>(for indexPath: IndexPath, with kind: String) -> T
    {
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.className, for: indexPath) as! T
    }
}
