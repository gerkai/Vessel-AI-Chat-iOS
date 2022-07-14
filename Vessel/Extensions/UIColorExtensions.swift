//
//  ColorExtensions.swift
//  vessel-ios
//
//  Created by Mark Tholking on 2/10/20.
//  Copyright © 2020 Vessel Health Inc. All rights reserved.
//

import UIKit

extension UIColor {
    static var transparentGray: UIColor { UIColor(hex: "#000000").withAlphaComponent(0.46) }
    static var linenYellow: UIColor { return UIColor(hex: "#FBF3EB") }
    static var grayText: UIColor { UIColor(hex: "#555553") }
    static var offwhite: UIColor { UIColor(hex: "#FDF6ED") }
    static var codGrey = UIColor(hex: "#161514")
    static var transparentCodGray: UIColor { UIColor(hex: "#161514").withAlphaComponent(0.7) }
    static var disabledGreyColor: UIColor = UIColor(hex: "#191917")
    static var backgroundLightGreen = UIColor(hex: "#DBEBD5")
    static var backgroundGreen = UIColor(hex: "#C1DEBA")
    static var backgroundGray = UIColor(hex: "#D4CBC5")
    static var backgroundRed = UIColor(hex: "#E7C4B1")
    static var backgroundLightRed = UIColor(hex: "#F1DCCE")
    static var darkGreyText = UIColor(hex: "#5A5A57")
    static var reddishBrown = UIColor(hex: "#E8B3A8")
    //static var greyText = UIColor(hex: "#555553")
    static var grayColor  = UIColor(hex: "#EAEBE5")
    static var pixieGreen = UIColor(hex: "#CBDEC0")
    static var willowGreen = UIColor(hex: "#E6F1E3")
    static var baseWhite = UIColor(hex: "#EAEBE5")
    static var backgroundLightPink = UIColor(hex: "#F2E5D7")
    static var backgroundPink = UIColor(hex: "#F4BCB0")
    static var blackAlpha7 = UIColor.black.withAlphaComponent(0.7)
    static var whiteAlpha7 = UIColor.white.withAlphaComponent(0.7)
    
    convenience init(hex string: String) {
      var hex = string.hasPrefix("#")
        ? String(string.dropFirst())
        : string
        guard hex.count == 3 || hex.count == 6 else
        {
            self.init(white: 1.0, alpha: 0.0)
            return
        }
        
        if hex.count == 3
        {
            for (index, char) in hex.enumerated()
            {
                hex.insert(char, at: hex.index(hex.startIndex, offsetBy: index * 2))
            }
        }
        
        guard let intCode = Int(hex, radix: 16) else
        {
            self.init(white: 1.0, alpha: 0.0)
            return
        }
        
        self.init(
            red: CGFloat((intCode >> 16) & 0xFF) / 255.0,
            green: CGFloat((intCode >> 8) & 0xFF) / 255.0,
            blue: CGFloat((intCode) & 0xFF) / 255.0, alpha: 1.0)
    }
}
