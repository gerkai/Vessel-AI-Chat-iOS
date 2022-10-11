//
//  TodayFoodDetailsSectionTableViewCell.swift
//  Vessel
//
//  Created by Nicolas Medina on 10/7/22.
//

import UIKit

class TodayFoodDetailsSectionTableViewCell: UITableViewCell
{
    @IBOutlet private weak var stackView: UIStackView!
    private var foods: [Food] = []
    private var checked: [Bool] = []
    private weak var delegate: FoodCheckmarkViewDelegate?
    
    func setup(foods: [Food], delegate: FoodCheckmarkViewDelegate)
    {
        self.foods = foods
        self.checked = Array(repeating: false, count: foods.count)
        stackView.removeAllArrangedSubviews()
        
        for (i, food) in foods.enumerated()
        {
            var horizontalStackView: UIStackView
            if i % 2 == 0
            {
                horizontalStackView = createStackView()
                stackView.addArrangedSubview(horizontalStackView)
            }
            else
            {
                horizontalStackView = stackView.arrangedSubviews[Int((i - 1) / 2)] as! UIStackView
            }
            
            let foodView = FoodCheckmarkView(frame: .zero)
            foodView.food = food
            foodView.isChecked = checked[i]
            foodView.delegate = delegate
            horizontalStackView.addArrangedSubview(foodView)
        }
        
        // If foods are odd, add an empty view to the last stack view to balance the views
        if foods.count % 2 != 0
        {
            (stackView.arrangedSubviews.last as? UIStackView)?.addArrangedSubview(UIView())
        }
    }
}

private extension TodayFoodDetailsSectionTableViewCell
{
    func createStackView() -> UIStackView
    {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 17.0
        stackView.alignment = .fill
        return stackView
    }
}
