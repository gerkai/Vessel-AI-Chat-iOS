//
//  GoalLearnMoreTileView.swift
//  ChartView
//
//  Created by Carson Whitsett on 9/25/22.
//
//  Caller can set numDots to 0, 1, 2 or 3

import UIKit

protocol GoalLearnMoreTileViewDelegate
{
    func didSelectGoal(id: Int, learnMore: Bool, animated: Bool)
}

class GoalLearnMoreTileView: UIView
{
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtextLabel: UILabel!
    @IBOutlet weak var learnMoreView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dotImageView: UIImageView!
    
    var delegate: GoalLearnMoreTileViewDelegate?
    var isSelected = false
    {
        didSet
        {
            self.learnMoreView.isHidden = !self.isSelected
        }
    }
    
    var numDots: Int = 2
    {
        didSet
        {
            //print("Setting numDots: \(numDots)")
            dotImageView.alpha = 1.0
            switch numDots
            {
                case 1:
                    dotImageView.image = UIImage(named: "dots-1")
                case 2:
                    dotImageView.image = UIImage(named: "dots-2")
                case 3:
                    dotImageView.image = UIImage(named: "dots-3")
                default:
                    dotImageView.image = UIImage(named: "dots-3")
                    dotImageView.alpha = 0.0
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
        self.backgroundColor = .clear
        learnMoreView.isHidden = true
    }
    
    @IBAction func pressed()
    {
        if isSelected
        {
            UIView.animate(withDuration: 0.1)
            {
                self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
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
        delegate?.didSelectGoal(id: tag, learnMore: wasSelected, animated: true)
    }
    
    func hide(_ vu: UIView)
    {
        if vu.isHidden == false
        {
            vu.isHidden = true
        }
    }

    func show(_ vu: UIView)
    {
        if vu.isHidden == true
        {
            vu.isHidden = false
        }
    }
}
