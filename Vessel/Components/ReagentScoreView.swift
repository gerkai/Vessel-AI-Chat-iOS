//
//  ReagentScoreView.swift
//  Vessel
//
//  Created by Carson Whitsett on 9/24/22.
//

import UIKit

class ReagentScoreView: UIView
{
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var score = 0.0
    {
        didSet
        {
            scoreLabel.text = "\(Int(score))"
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
    }
}
