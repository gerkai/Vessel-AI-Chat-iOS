//
//  ReagentTileView.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/26/22.
//

import UIKit

class ReagentTileView: UIView
{
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtextLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var endFrame = CGRect()
    var startFrame = CGRect()
    var tempFrame = CGRect()
    
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
