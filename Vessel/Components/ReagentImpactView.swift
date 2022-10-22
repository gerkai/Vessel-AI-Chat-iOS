//
//  ReagentImpactView.swift
//  Vessel
//
//  Created by Carson Whitsett on 10/21/22.
//

import UIKit

protocol ReagentImpactViewDelegate: AnyObject
{
    func reagentImpactViewTapped()
}

class ReagentImpactView: UIView
{
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var reagentNameLabel: UILabel!
    @IBOutlet weak var evaluationLabel: UILabel!
    @IBOutlet weak var impactImageView: UIImageView!
    weak var delegate: ReagentImpactViewDelegate?
    
    var numDots: Int = 2
    {
        didSet
        {
            //print("Setting numDots: \(numDots)")
            impactImageView.alpha = 1.0
            switch numDots
            {
                case 1:
                    impactImageView.image = UIImage(named: "dots-1")
                case 2:
                    impactImageView.image = UIImage(named: "dots-2")
                case 3:
                    impactImageView.image = UIImage(named: "dots-3")
                default:
                    impactImageView.image = UIImage(named: "dots-3")
                    impactImageView.alpha = 0.0
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
        //self.backgroundColor = .clear
        
    }
    
    @IBAction func tapped()
    {
        delegate?.reagentImpactViewTapped()
    }
}
