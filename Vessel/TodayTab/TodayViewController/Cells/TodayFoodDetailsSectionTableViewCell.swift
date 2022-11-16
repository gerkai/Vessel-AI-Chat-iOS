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
            foodView.delegate = delegate
            horizontalStackView.addArrangedSubview(foodView)
        }
        updateCheckedFoods()
        
        // If foods are odd, add an empty view to the last stack view to balance the views
        if foods.count % 2 != 0
        {
            (stackView.arrangedSubviews.last as? UIStackView)?.addArrangedSubview(UIView())
        }
    }
    
    func updateCheckedFoods()
    {
        guard let contact = Contact.main() else { return }
        checked = PlansManager.shared.plans.filter
        { plan in
            contact.suggestedFoods.contains(where: { $0.id == plan.foodId })
        }.map({ $0.isComplete })
        
        for (i, view) in stackView.arrangedSubviews.enumerated()
        {
            guard let stackView = view as? UIStackView else { return }
            if let foodView = stackView.arrangedSubviews[safe: 0] as? FoodCheckmarkView
            {
                if foodView.isChecked != checked[i * 2]
                {
                    foodView.isChecked = checked[i * 2]
                }
            }
            if let foodView = stackView.arrangedSubviews[safe: 1] as? FoodCheckmarkView
            {
                if foodView.isChecked != checked[(i * 2) + 1]
                {
                    foodView.isChecked = checked[(i * 2) + 1]
                }
            }
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
