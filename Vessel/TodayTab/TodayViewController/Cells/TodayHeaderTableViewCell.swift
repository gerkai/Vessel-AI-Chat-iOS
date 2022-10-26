//
//  TodayHeaderTableViewCell.swift
//  Vessel
//
//  Created by Nicolas Medina on 9/26/22.
//

import UIKit

protocol TodayHeaderTableViewCellDelegate: AnyObject
{
    func onGoalTapped(goal: String)
}

class TodayHeaderTableViewCell: UITableViewCell
{
    // MARK: - UI
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    
    var goals = [String]()
    
    weak var delegate: TodayHeaderTableViewCellDelegate?

    // MARK: - Methods
    func setup(name: String, goals: [String], delegate: TodayHeaderTableViewCellDelegate)
    {
        self.goals = goals
        self.delegate = delegate
        
        titleLabel.text = NSLocalizedString("Hi \(name.capitalized)!", comment: "Greetings message")
        
        subtitleLabel.text = NSLocalizedString("Today's plan for \(goals.joined(separator: ", ")).", comment: "Subtitle message")
        
        let newsString: NSMutableAttributedString = NSMutableAttributedString(string: subtitleLabel.text!)
        let textRange = NSString(string: subtitleLabel.text!)
        for goal in goals
        {
            let substringRange = textRange.range(of: goal) // You can add here for own specific under line substring
            newsString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: substringRange)
        }
        subtitleLabel.attributedText = newsString
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapResponse))
        subtitleLabel.isUserInteractionEnabled = true
        subtitleLabel.addGestureRecognizer(tapGesture)
    }
}

private extension TodayHeaderTableViewCell
{
    @objc
    func tapResponse(gestureRecognizer: UITapGestureRecognizer)
    {
        let text = (subtitleLabel.text)!
        guard let firstGoal = goals[safe: 0] else { return }
        let firstGoalRange = (text as NSString).range(of: firstGoal)
        if (gestureRecognizer.didTapAttributedTextInLabel(label: subtitleLabel, inRange: firstGoalRange))
        {
            self.delegate?.onGoalTapped(goal: firstGoal)
        }
        guard let secondGoal = goals[safe: 1] else { return }
        let secondGoalRange = (text as NSString).range(of: secondGoal)
        if (gestureRecognizer.didTapAttributedTextInLabel(label: subtitleLabel, inRange: secondGoalRange))
        {
            self.delegate?.onGoalTapped(goal: secondGoal)
        }
        guard let thirdGoal = goals[safe: 2] else { return }
        let thirdGoalRange = (text as NSString).range(of: thirdGoal)
        if (gestureRecognizer.didTapAttributedTextInLabel(label: subtitleLabel, inRange: thirdGoalRange))
        {
            self.delegate?.onGoalTapped(goal: thirdGoal)
        }
    }
}

extension UITapGestureRecognizer
{
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool
    {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        if indexOfCharacter == targetRange.location + targetRange.length
        {
            return true
        }
        else
        {
            return NSLocationInRange(indexOfCharacter, targetRange)
        }
    }
}
