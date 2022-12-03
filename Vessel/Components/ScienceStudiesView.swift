//
//  ScienceStudiesView.swift
//  Vessel
//
//  Created by Carson Whitsett on 10/17/22.
//

import UIKit

protocol ScienceStudiesViewDelegate: AnyObject
{
    func didSelectStudy(buttonID: Int)
}

class ScienceStudiesView: UIView
{
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var studiesLabel: UILabel!
    
    var goal: String
    var numStudies: String
    weak var delegate: ScienceStudiesViewDelegate?
    
    init(goalID: Goal.ID, studies: String)
    {
        goal = Goals[goalID]!.name.capitalized
        numStudies = studies
        let frame = CGRect(x: 0, y: 0, width: 120, height: 60)
        super.init(frame: frame)
        tag = goalID.rawValue
        commonInit()
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit
    {
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("ScienceStudiesView DEINIT")
        }
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
    
    @IBAction func buttonPressed()
    {
        delegate?.didSelectStudy(buttonID: tag)
    }
}
