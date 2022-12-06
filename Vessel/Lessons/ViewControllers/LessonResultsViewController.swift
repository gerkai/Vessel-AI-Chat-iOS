//
//  LessonResultsViewController.swift
//  Vessel
//
//  Created by Nicolas Medina on 11/28/22.
//

import UIKit

class LessonResultsViewController: UIViewController
{
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var successfulLessonIcon: UIImageView!
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var confettiImageView: UIImageView!
    @IBOutlet private weak var confettiTopConstraint: NSLayoutConstraint!
    
    private let successTitles = [NSLocalizedString("Nice!", comment: ""), NSLocalizedString("Well Done!", comment: ""), NSLocalizedString("Nailed it!", comment: "")]
    private let failureTitles = [NSLocalizedString("Almost", comment: ""), NSLocalizedString("So Close", comment: ""), NSLocalizedString("Not Quite", comment: "")]
    private var titleText: String
    {
        if success
        {
            return successTitles[Int.random(in: 0..<successTitles.count)]
        }
        else
        {
            return failureTitles[Int.random(in: 0..<failureTitles.count)]
        }
    }
    
    var success: Bool = true
    var imageUrl: String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        titleLabel.text = titleText
        successfulLessonIcon.isHidden = !success
        guard let imageUrl = imageUrl,
              let url = URL(string: imageUrl) else { return }
        backgroundImageView.kf.setImage(with: url)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.navigationController?.fadeOut()
        })
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        if success
        {
            confettiTopConstraint.constant = -view.frame.height
            UIView.animate(withDuration: 2.0, delay: 0.0)
            {
                self.view.layoutIfNeeded()
            }
        }
    }
}
