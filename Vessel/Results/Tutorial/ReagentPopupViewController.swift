//
//  ReagentPopupViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 9/6/22.
//

import UIKit

class ReagentPopupViewController: PopupViewController
{
    @IBOutlet weak var reagentTileView: ReagentLearnMoreTileView!
    weak var sourceTile: ReagentLearnMoreTileView!
    
    static func createWith(reagentTile: ReagentLearnMoreTileView) -> ReagentPopupViewController
    {
        let storyboard = UIStoryboard(name: "Results", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ReagentPopupViewController") as! ReagentPopupViewController
        vc.sourceTile = reagentTile
        
        return vc
    }
    
    override func viewDidLoad()
    {
        reagentTileView.alpha = 0.0
        reagentTileView.frame = sourceTile.frame
        reagentTileView.imageView.image = sourceTile.imageView.image
        reagentTileView.titleLabel.text = sourceTile.titleLabel.text
        reagentTileView.subtextLabel.text = sourceTile.subtextLabel.text
        reagentTileView.learnMoreView.isHidden = sourceTile.learnMoreView.isHidden
        reagentTileView.contentView.backgroundColor = sourceTile.contentView.backgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        let frame = sourceTile.superview!.convert(sourceTile.frame, to: self.view)
        reagentTileView.frame = frame
    }
    
    override func appearAnimations()
    {
        self.reagentTileView.alpha = 1.0
    }
    
    override func dismissAnimations()
    {
        self.reagentTileView.alpha = 0.0
    }
    
    @IBAction func gotIt()
    {
        dismissAnimation
        {
        }
    }
}
