//
//  VesselFooterView.swift
//  Vessel
//
//  Created by Nicolas Medina on 10/4/22.
//

import UIKit

class VesselFooterView: UIView
{
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var vesselIcon: UIImageView!
    
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
        contentView.backgroundColor = .codGray
    }
}
