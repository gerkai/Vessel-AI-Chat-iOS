//
//  ExpandableContentView.swift
//  Vessel
//
//  Created by Carson Whitsett on 10/18/22.
//

import UIKit

class ExpandableContentView: UIView
{
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var longLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    var delegate: SourceInfoViewDelegate?
    var title: String!
    var info: NSAttributedString!
    var expanded = false
    var origNumberOfLines: Int!
    
    init(title: String, info: NSAttributedString)
    {
        let frame = CGRect(x: 0, y: 0, width: 120, height: 60)
        super.init(frame: frame)
        self.title = title
        self.info = info
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
        titleLabel.text = title
        infoLabel.attributedText = info
        longLabel.attributedText = info
        longLabel.isHidden = true
        origNumberOfLines = infoLabel.numberOfLines
    }
    
    @IBAction func more()
    {
        //infoToMoreConstraint.isActive = false
        moreButton.isHidden = true
        //infoLabel.numberOfLines = 0
        longLabel.isHidden = false
        infoLabel.isHidden = true
        UIView.animate(withDuration: 0.25, animations:
        {
            self.parentViewController?.view.layoutIfNeeded()
        })
        { done in
            self.expanded = true
        }
    }
    
    @IBAction func shrink()
    {
        if expanded
        {
            moreButton.isHidden = false
            longLabel.isHidden = true
            infoLabel.isHidden = false
            UIView.animate(withDuration: 0.25, animations:
            {
                self.parentViewController?.view.layoutIfNeeded()
            })
            { done in
                self.expanded = false
            }
        }
    }
}
