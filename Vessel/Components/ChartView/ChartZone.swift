//
//  ChartZone.swift
//  Vessel
//
//  Created by Carson Whitsett on 10/14/22.
//

import UIKit

class ChartZone: UIView
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    
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
        
        titleLabel.transform = CGAffineTransform(rotationAngle: -.pi / 2)
        self.backgroundColor = .clear
    }
}
