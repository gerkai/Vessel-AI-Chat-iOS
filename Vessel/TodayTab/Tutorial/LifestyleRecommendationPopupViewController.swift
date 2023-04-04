//
//  GetSupplementPlanPopupViewController.swift
//  Vessel
//
//  Created by Nicolas Medina on 3/31/23.
//

import UIKit

class LifestyleRecommendationPopupViewController: PopupViewController
{
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityTitle: UILabel!
    @IBOutlet weak var activitySubtitle: UILabel!
    @IBOutlet weak var activityDescription: UILabel!
    @IBOutlet weak var activityImageView: UIImageView!
    var plan: Plan!
    
    static func createWith(plan: Plan) -> LifestyleRecommendationPopupViewController
    {
        let storyboard = UIStoryboard(name: "TodayTab", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LifestyleRecommendationPopupViewController") as! LifestyleRecommendationPopupViewController
        vc.plan = plan
        
        return vc
    }
    
    override func viewDidLoad()
    {
        ObjectStore.shared.get(type: LifestyleRecommendation.self, id: plan.typeId)
        { lifestyleReccomendation in
            self.activityTitle.text = lifestyleReccomendation.title
            self.activitySubtitle.text = lifestyleReccomendation.subtext
            if let imageURL = lifestyleReccomendation.imageURL, let url = URL(string: imageURL)
            {
                self.activityImageView.kf.setImage(with: url)
            }
            self.activityDescription.text = lifestyleReccomendation.description
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
