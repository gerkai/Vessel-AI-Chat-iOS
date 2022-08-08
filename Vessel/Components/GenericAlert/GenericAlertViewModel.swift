//
//  GenericAlertViewModel.swift
//  Vessel
//
//  Created by Nicolas Medina on 8/2/22.
//

import Foundation
import UIKit

enum GenericAlertBackground
{
    case cream
    case green
}

enum GenericAlertAlignment
{
    case bottom
    case center
}

protocol GenericAlertDelegate: AnyObject
{
    func onAlertPresented()
    func onAlertButtonTapped(index: Int)
    func onAlertDismissed()
}

enum GenericAlertButtonType
{
    case dark
    case gray
    case clear
    case plain
}

struct GenericAlertButtonInfo
{
    var label: GenericAlertLabelInfo
    var type: GenericAlertButtonType
    var image: UIImage?
}

struct GenericAlertLabelInfo
{
    let title: String
    let font: UIFont?
    let color: UIColor?
    let numberLines: Int?
    let lineBreak: NSLineBreakMode?
    let alignment: NSTextAlignment?
    let height: CGFloat?
    let attributedString: NSAttributedString?
    
    init(title: String,
         font: UIFont? = nil,
         color: UIColor? = nil,
         numberLines: Int? = nil,
         alignment: NSTextAlignment? = nil,
         lineBreak: NSLineBreakMode? = nil,
         height: CGFloat? = nil,
         attributedString: NSAttributedString? = nil)
    {
        self.title = title
        self.font = font
        self.color = color
        self.numberLines = numberLines
        self.alignment = alignment
        self.lineBreak = lineBreak
        self.height = height
        self.attributedString = attributedString
    }
}

enum GenericAlertType
{
    case title(text: GenericAlertLabelInfo)
    case titleButton(text: GenericAlertLabelInfo, button: GenericAlertButtonInfo)
    case titleButtons(title: GenericAlertLabelInfo, buttons: [GenericAlertButtonInfo])
    case titleHorizontalButtons(title: GenericAlertLabelInfo, buttons: [GenericAlertButtonInfo])
    case titleSubtitle(title: GenericAlertLabelInfo, subtitle: GenericAlertLabelInfo)
    case titleSubtitleButton(title: GenericAlertLabelInfo, subtitle: GenericAlertLabelInfo, button: GenericAlertButtonInfo)
    case titleSubtitleButtons(title: GenericAlertLabelInfo, subtitle: GenericAlertLabelInfo, buttons: [GenericAlertButtonInfo])
    case titleSubtitleHorizontalButtons(title: GenericAlertLabelInfo, subtitle: GenericAlertLabelInfo, buttons: [GenericAlertButtonInfo])
    case imageTitleSubtitleButton(image: UIImage, title: GenericAlertLabelInfo, subtitle: GenericAlertLabelInfo, button: GenericAlertButtonInfo)
    case imageTitleSubtitleButtons(image: UIImage, title: GenericAlertLabelInfo, subtitle: GenericAlertLabelInfo, buttons: [GenericAlertButtonInfo])
    case imageTitleSubtitleHorizontalButtons(image: UIImage, title: GenericAlertLabelInfo, subtitle: GenericAlertLabelInfo, buttons: [GenericAlertButtonInfo])
    case imageSubtitleButton(image: UIImage, subtitle: GenericAlertLabelInfo, button: GenericAlertButtonInfo)
    case titleCustomView(title: GenericAlertLabelInfo, view: UIView)
    case titleCustomViewButton(title: GenericAlertLabelInfo, view: UIView, button: GenericAlertButtonInfo)
    case customView(view: UIView)
    case customViewButton(view: UIView, button: GenericAlertButtonInfo)
}

class GenericAlertViewModel
{
    var type: GenericAlertType
    var background: GenericAlertBackground
    var showCloseButton: Bool
    var alignment: GenericAlertAlignment
    var shouldCloseWhenButtonTapped: Bool
    var shouldCloseWhenTappedOutside: Bool
    
    init(type: GenericAlertType,
         background: GenericAlertBackground = .cream,
         showCloseButton: Bool = false,
         alignment: GenericAlertAlignment = .center,
         shouldCloseWhenButtonTapped: Bool = true,
         shouldCloseWhenTappedOutside: Bool = true)
    {
        self.type = type
        self.background = background
        self.showCloseButton = showCloseButton
        self.alignment = alignment
        self.shouldCloseWhenButtonTapped = shouldCloseWhenButtonTapped
        self.shouldCloseWhenTappedOutside = shouldCloseWhenTappedOutside
    }
}
