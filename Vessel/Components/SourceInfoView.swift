//
//  SourceInfoView.swift
//  Vessel
//
//  Created by Carson Whitsett on 10/18/22.
//

import UIKit

protocol SourceInfoViewDelegate
{
    func moreButtonPressed(url: String)
}

class SourceInfoView: UIView
{
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    
    var delegate: SourceInfoViewDelegate?
    var content: String!
    var url: String!
    
    init(content: String, url: String)
    {
        let frame = CGRect(x: 0, y: 0, width: 120, height: 60)
        super.init(frame: frame)
        self.content = content
        self.url = url
        commonInit()
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit()
    {
        let xibName = String(describing: type(of: self))
        
        Bundle.main.loadNibNamed(xibName, owner: self, options: nil)
        contentView.fixInView(self)
        infoLabel.text = content
    }
    
    @IBAction func more()
    {
        delegate?.moreButtonPressed(url: url)
    }
}
