//
//  InsightsPopupViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 9/6/22.
//

import UIKit

protocol InsightsPopupViewControllerDelegate
{
}

class InsightsPopupViewController: PopupViewController
{
    @IBOutlet weak var lessonView: UIView!
    @IBOutlet weak var lessonTitle: UILabel!
    @IBOutlet weak var lessonSubtitle: UILabel!
    @IBOutlet weak var lessonDescription: UILabel!
    @IBOutlet weak var lessonImageView: UIImageView!
    var delegate: InsightsPopupViewControllerDelegate?
    
    override func viewDidLoad()
    {
        if let lesson = LessonsManager.shared.nextLesson
        {
            lessonTitle.text = lesson.title
            lessonSubtitle.text = lesson.subtitleString()
            if let url = URL(string: lesson.imageUrl ?? "")
            {
                lessonImageView.kf.setImage(with: url)
            }
            lessonDescription.text = lesson.description
            lessonView.alpha = 0.0
        }
        else
        {
            lessonView.isHidden = true
        }
    }
    override func appearAnimations()
    {
        self.lessonView.alpha = 1.0
    }
    
    override func dismissAnimations()
    {
        self.lessonView.alpha = 0.0
    }
    
    @IBAction func gotIt()
    {
        dismissAnimation
        {
        }
    }
}
