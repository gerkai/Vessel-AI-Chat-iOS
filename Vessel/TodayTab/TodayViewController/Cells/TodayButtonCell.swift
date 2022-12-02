//
//  TodayButtonCell.swift
//  Vessel
//
//  Created by Nicolas Medina on 11/30/22.
//

import UIKit

protocol TodayButtonCellDelegate: AnyObject
{
    func onButtonPressed()
}

class TodayButtonCell: UITableViewCell
{
    @IBOutlet weak var button: BounceButton!
    private weak var delegate: TodayButtonCellDelegate?
    
    func setup(title: String, delegate: TodayButtonCellDelegate)
    {
        self.delegate = delegate
        button.setTitle(title, for: .normal)
    }
    
    @IBAction func onButtonTapped()
    {
        delegate?.onButtonPressed()
    }
}
