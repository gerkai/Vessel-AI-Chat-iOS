//
//  ReagentImpactView.swift
//  Vessel
//
//  Created by Carson Whitsett on 10/21/22.
//

import UIKit

protocol ReagentImpactViewDelegate: AnyObject
{
    func reagentImpactViewTappedImpact()
    func reagentImpactViewTappedReagent(reagentId: Int)
}

class ReagentImpactView: UIView
{
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var reagentNameLabel: UILabel!
    @IBOutlet weak var evaluationLabel: UILabel!
    @IBOutlet weak var impactImageView: UIImageView!
    @IBOutlet weak var reagentImpactView: UIView!
    
    weak var delegate: ReagentImpactViewDelegate?
    
    var reagentId: Int?
    var numDots: Int = 2
    {
        didSet
        {
            switch numDots
            {
                case 1:
                    impactImageView.image = UIImage(named: "dots-1")
                case 2:
                    impactImageView.image = UIImage(named: "dots-2")
                case 3:
                    impactImageView.image = UIImage(named: "dots-3")
                default:
                    impactImageView.image = UIImage(named: "dots-0")
            }
        }
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit()
    {
        let xibName = String(describing: type(of: self))
        
        Bundle.main.loadNibNamed(xibName, owner: self, options: nil)
        contentView.fixInView(self)
        
        reagentImpactView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(impactTapped)))
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
    }
    
    @objc
    func viewTapped(gestureRecognizer: UITapGestureRecognizer)
    {
        guard let reagentId = reagentId else
        {
            assertionFailure("ReagentImpactView-viewTapped: ReagentId not available")
            return
        }
        delegate?.reagentImpactViewTappedReagent(reagentId: reagentId)
    }
    
    @objc
    func impactTapped(gestureRecognizder: UITapGestureRecognizer)
    {
        delegate?.reagentImpactViewTappedImpact()
    }
}
