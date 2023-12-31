//
//  ChartViewCell.swift
//  ChartView
//
//  Created by Carson Whitsett on 9/20/22.
//
//  to change the range of the plot area, modify the graphView top and bottom constraints.

import UIKit

protocol ChartViewCellDelegate: AnyObject
{
    func cellTapped(id: Int)
    func cellInfoTapped()
}

class ChartViewCell: UICollectionViewCell
{
    @IBOutlet weak var infoHeight: NSLayoutConstraint!
    @IBOutlet weak var frostedView: UIView!
    @IBOutlet weak var graphView: GraphView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var scoreLabelYPosition: NSLayoutConstraint!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    var score: CGFloat = 0.0 //This variable is overridden in ResultsChartCell and ReagentDetailsChartCell classes
    weak var delegate: ChartViewCellDelegate?
    var originalHeight: Double!
    var animatingSelected = false
    var animatingUnselected = false
    var selectedHeightOffset = 0.0
    var parentTag = 0
    
    override func awakeFromNib()
    {
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("✳️ \(self)")
        }
        super.awakeFromNib()
        originalHeight = infoHeight.constant
        NotificationCenter.default.addObserver(self, selector: #selector(self.selected(_:)), name: .selectChartViewCell, object: nil)
    }
    
    deinit
    {
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("❌ \(self)")
        }
        NotificationCenter.default.removeObserver(self)
    }
    
    func setRandomBackground()
    {
        backgroundColor = UIColor(hue: CGFloat(drand48()), saturation: 1, brightness: 1, alpha: 1)
    }
    
    func select(selectionIntent: Bool)
    {
       // print("SELECT CELL")
        graphView.isSelected = selectionIntent
        graphView.layoutIfNeeded()
        if selectionIntent
        {
            //print("ChartViewCell: Select")
            infoHeight.constant = frame.height - selectedHeightOffset
            infoView.alpha = 1.0
            setScoreLabelPosition()
        }
        else
        {
            infoHeight.constant = originalHeight
            infoView.alpha = 0.0
        }
    }
    
    func setScoreLabelPosition()
    {
        //print("setScoreLabelPosition for cell: \(tag)")
        //print("frame: \(frame), graphViewFrame: \(graphView.frame)")
        //sets the infoView bottom to be slightly above the plotted dot in the graphView
        graphView.layoutIfNeeded()
        //get position from the coordinate plotted in the graphView and convert point to same location in our view
        let coordinate = graphView.convert(graphView.coordFor(index: 2), to: self)  //index 2 is the displayed point
        
        scoreLabelYPosition.constant = coordinate.y - 5.0 //bump it up slightly
    }
    
    @objc func selected(_ notification: NSNotification)
    {
        let selectedHeight = frame.height - selectedHeightOffset
        if let cell = notification.userInfo?["cell"] as? Int
        {
            //print("\(parentTag) Got Selected notification for cell: \(cell)")
            if cell == tag
            {
                //animate to selected state
                if notification.userInfo?["animated"] as? Bool == true
                {
                    //print("Selecting cell \(tag) ANIMATED")
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
                            self.animatingSelected = false
                            if self.infoHeight.constant == selectedHeight
                            {
                                self.graphView.isSelected = true
                                self.infoView.alpha = 1.0
                                self.setScoreLabelPosition()
                            }
                        }
                    }
                }
                else
                {
                    //print("Selecting cell \(tag)")
                    self.infoHeight.constant = selectedHeight
                    self.graphView.isSelected = true
                    self.infoView.alpha = 1.0
                    self.setScoreLabelPosition()
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
