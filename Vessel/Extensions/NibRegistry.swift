//
//  NibRegistry.swift
//  Vessel
//
//  Created by Carson Whitsett on 3/6/22.
//
//  Use this extension to cleanly instantiate Nibs from bundles without using string literals.
//
//  Example usage:
//      Bundle.main.loadNib(.lifeMeter, owner: self, options: nil)
//

import UIKit

extension Bundle
{
    // When creating new storyboards, name the file using a CamelCaseName and insert the new enum-case alphabetically here.
    public enum NibName: String, CaseIterable
    {
        case selectionCheckmarkView

        var filename: String
        {
            rawValue.firstUppercased
        }
    }

    @discardableResult
    public func loadNib(_ name: NibName, owner: Any?, options: [UINib.OptionsKey: Any]? = nil) -> [Any]?
    {
        loadNibNamed(name.filename, owner: owner, options: options)
    }
}
