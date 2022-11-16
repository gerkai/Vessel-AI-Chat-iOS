//
//  ReagentLearnMoreTileView.swift
//  ChartView
//
//  Created by Carson Whitsett on 9/25/22.
//

import UIKit

protocol ReagentLearnMoreTileViewDelegate
{
    func didSelectReagent(id: Int, learnMore: Bool, animated: Bool)
}

class ReagentLearnMoreTileView: UIView
{
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtextLabel: UILabel!
    @IBOutlet weak var learnMoreView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    var delegate: ReagentLearnMoreTileViewDelegate?
    var isSelected = false
    {
        didSet
        {
            self.learnMoreView.isHidden = !self.isSelected
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
        self.backgroundColor = .clear
        learnMoreView.isHidden = true
    }
    
    @IBAction func pressed()
    {
        UIView.animate(withDuration: 0.1)
        {
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
    }
    
    @IBAction func tapCancelled()
    {
        UIView.animate(withDuration: 0.1)
        {
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    @IBAction func tapped()
    {
        UIView.animate(withDuration: 0.1)
        {
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        let wasSelected = isSelected
        isSelected = true
        delegate?.didSelectReagent(id: tag, learnMore: wasSelected, animated: true)
    }
}
