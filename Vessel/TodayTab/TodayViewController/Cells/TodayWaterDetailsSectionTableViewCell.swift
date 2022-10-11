//
//  TodayWaterDetailsSectionTableViewCell.swift
//  Vessel
//
//  Created by Nicolas Medina on 10/6/22.
//

import UIKit

class TodayWaterDetailsSectionTableViewCell: UITableViewCell
{
    @IBOutlet private weak var waterIntakeView: WaterIntakeView!
    
    func setup(glassesNumber: Int, checkedGlasses: Int, delegate: WaterIntakeViewDelegate?)
    {
        waterIntakeView.waterIntakeViewType = .green
        waterIntakeView.numberOfGlasses = glassesNumber
        waterIntakeView.checkedGlasses = checkedGlasses
        waterIntakeView.delegate = delegate
    }
}
