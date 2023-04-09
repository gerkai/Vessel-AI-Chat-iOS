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
    var selectedDate: String = ""
    var isToday: Bool = false
    
    func setup(foods: [Food], selectedDate: String, isToday: Bool, delegate: FoodCheckmarkViewDelegate)
    {
        self.foods = foods
        self.selectedDate = selectedDate
        self.isToday = isToday
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
        guard let contact = Contact.main() else
        {
            assertionFailure("TodayFoodDetailsSectionTableViewCell-updateCheckedFoods: mainContact not available")
            return
        }
        let foodPlans = PlansManager.shared.getFoodPlans(shouldFilterForToday: isToday, shouldFilterForSelectedDay: selectedDate).sorted(by: { $0.typeId < $1.typeId }).filter
        { plan in
            return contact.suggestedFoods.contains(where: { $0.id == plan.typeId })
        }
        
        checked = foodPlans.map({ $0.completed.contains(selectedDate) })
        
        for (i, view) in stackView.arrangedSubviews.enumerated()
        {
            guard let stackView = view as? UIStackView else
            {
                assertionFailure("TodayFoodDetailsSectionTableViewCell-updateCheckedFoods: Couldn't parse view as stackView")
                return
            }
            if let foodView = stackView.arrangedSubviews[safe: 0] as? FoodCheckmarkView
            {
                foodView.isChecked = checked[i * 2]
            }
            if let foodView = stackView.arrangedSubviews[safe: 1] as? FoodCheckmarkView
            {
                foodView.isChecked = checked[(i * 2) + 1]
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
