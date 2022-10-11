//
//  ChartViewCell.swift
//  ChartView
//
//  Created by Carson Whitsett on 9/20/22.
//
//  to change the range of the plot area, modify the graphView top and bottom constraints.

import UIKit

protocol ChartViewCellDelegate
{
    func cellTapped(id: Int)
    func cellInfoTapped()
}

class ChartViewCell: UICollectionViewCell
{
    @IBOutlet weak var infoHeight: NSLayoutConstraint!
    @IBOutlet weak var frostedView: UIView!
    @IBOutlet weak var graphView: GraphView!
    @IBOutlet weak var wellnessScoreLabel: UILabel!
    @IBOutlet weak var wellnessLabelYPosition: NSLayoutConstraint!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    var wellnessScore: CGFloat = 0.0
    var delegate: ChartViewCellDelegate?
    var originalHeight: Double!
    var animatingSelected = false
    var animatingUnselected = false
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        originalHeight = infoHeight.constant
        NotificationCenter.default.addObserver(self, selector: #selector(self.selected(_:)), name: .selectChartViewCell, object: nil)
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setRandomBackground()
    {
        backgroundColor = UIColor(hue: CGFloat(drand48()), saturation: 1, brightness: 1, alpha: 1)
    }
    
    func select(selectionIntent: Bool)
    {
        if selectionIntent
        {
            infoHeight.constant = frame.height
        }
        else
        {
            infoHeight.constant = originalHeight
        }
        graphView.isSelected = selectionIntent
    }
    
    @objc func selected(_ notification: NSNotification)
    {
        let selectedHeight = frame.height
        if let cell = notification.userInfo?["cell"] as? Int
        {
            if cell == tag
            {
                //animate to selected state
                if notification.userInfo?["animated"] as? Bool == true
                {
                    //print("Selecting cell \(tag) ANIMATED with wellness: \(wellnessScoreLabel.text)")
                    if animatingSelected == false
                    {
                        animatingSelected = true
                        UIView.animate(withDuration: 0.1, delay: 0.0 /*, options: .beginFromCurrentState*/)
                        {
                            self.infoHeight.constant = selectedHeight
                            self.layoutIfNeeded()
                        }
                    completion:
                        { finished in
                            if finished == true
                            {
                                self.animatingSelected = false
                                if self.infoHeight.constant == selectedHeight
                                {
                                    self.graphView.isSelected = true
                                    self.infoView.alpha = 1.0
                                    self.wellnessLabelYPosition.constant = -self.wellnessScore * (self.graphView.bounds.height - self.graphView.pointRegionSize) - 30.0
                                }
                            }
                        }
                    }
                }
                else
                {
                    //print("Selecting cell \(tag) with wellness: \(wellnessScoreLabel.text)")
                    self.infoHeight.constant = selectedHeight
                    self.graphView.isSelected = true
                    self.infoView.alpha = 1.0
                    self.wellnessLabelYPosition.constant = -self.wellnessScore * (self.graphView.bounds.height - self.graphView.pointRegionSize) - 30.0
                    self.animatingSelected = false
                }
            }
            else
            {
                //animate to unselected state
                
                if notification.userInfo?["animated"] as? Bool == true
                {
                    if animatingUnselected == false
                    {
                        //print("Unselecting cell ANIMATED \(tag)")
                        self.graphView.isSelected = false
                        self.infoView.alpha = 0.0
                        animatingUnselected = true
                        animatingSelected = false
                        UIView.animate(withDuration: 0.1, delay: 0.0 /*, options: .beginFromCurrentState*/)
                        {
                            self.infoHeight.constant = self.originalHeight
                            self.layoutIfNeeded()
                        }
                    completion:
                        { _ in
                            self.animatingUnselected = false
                        }
                    }
                }
                else
                {
                    //print("Unselecting cell \(tag)")
                    self.graphView.isSelected = false
                    self.infoView.alpha = 0.0
                    self.infoHeight.constant = self.originalHeight
                    self.animatingUnselected = false
                }
            }
        }
    }
    
    @IBAction func tap()
    {
        delegate?.cellTapped(id: tag)
    }
    
    @IBAction func infoTap()
    {
        delegate?.cellInfoTapped()
    }
}
