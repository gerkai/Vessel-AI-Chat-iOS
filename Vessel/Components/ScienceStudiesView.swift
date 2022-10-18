//
//  ScienceStudiesView.swift
//  Vessel
//
//  Created by Carson Whitsett on 10/17/22.
//

import UIKit

class ScienceStudiesView: UIView
{
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var studiesLabel: UILabel!
    
    var goal: String
    var numStudies: String
    
    init(goalName: String, studies: String)
    {
        goal = goalName
        numStudies = studies
        let frame = CGRect(x: 0, y: 0, width: 120, height: 60)
        super.init(frame: frame)
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
        self.backgroundColor = .clear
        goalLabel.text = goal
        studiesLabel.text = numStudies
    }
}
