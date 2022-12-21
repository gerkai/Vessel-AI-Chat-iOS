//
//  ReagentPopupViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 9/6/22.
//

import UIKit

class ReagentPopupViewController: PopupViewController
{
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityTitle: UILabel!
    @IBOutlet weak var activitySubtitle: UILabel!
    @IBOutlet weak var activityDescription: UILabel!
    @IBOutlet weak var activityImageView: UIImageView!
    var plan: Plan!
    
    static func createWith(plan: Plan) -> ReagentPopupViewController
    {
        let storyboard = UIStoryboard(name: "Results", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ReagentPopupViewController") as! ReagentPopupViewController
        vc.plan = plan
        
        return vc
    }
    
    override func viewDidLoad()
    {
        ObjectStore.shared.get(type: Tip.self, id: plan.typeId)
        { activity in
            self.activityTitle.text = activity.title
            self.activitySubtitle.text = ""
            if let url = URL(string: activity.imageUrl)
            {
                self.activityImageView.kf.setImage(with: url)
            }
            self.activityDescription.text = activity.description
            self.activityView.alpha = 0.0
        }
        onFailure:
        {
            self.activityView.isHidden = true
        }
    }
    
    override func appearAnimations()
    {
        self.activityView.alpha = 1.0
    }
    
    override func dismissAnimations()
    {
        self.activityView.alpha = 0.0
    }
    
    @IBAction func gotIt()
    {
        dismissAnimation
        {
        }
    }
}
