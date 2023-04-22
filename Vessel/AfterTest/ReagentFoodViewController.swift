//
//  ReagentFoodViewController.swift
//  Vessel
//
//  Created by Nicolas Medina on 10/12/22.
//

import UIKit

class ReagentFoodViewController: AfterTestMVVMViewController
{
    // MARK: - View
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var nextButton: BounceButton!
    
    var titleText: String!
    var reagentId: Int?
    
    // MARK: - UIView Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        viewModel.refreshSelectedFood()
        subtitleLabel.text = ""
        if let reagentId = reagentId
        {
            viewModel.loadFoodForReagent(reagentId: reagentId)
            { [weak self] in
                guard let self = self else { return }
                self.tableView.reloadData()
                self.updateSubtitle()
            }
            onFailure:
            { error in
                UIView.showError(text: "", detailText: error)
            }
        }
        else
        {
            viewModel.loadFoodForReagent(reagentId: nil)
            { [weak self] in
                guard let self = self else { return }
                self.tableView.reloadData()
                self.updateSubtitle()
            }
            onFailure:
            { error in
                UIView.showError(text: "", detailText: error)
            }
        }
        titleLabel.text = titleText
        let inset = UIEdgeInsets(top: 28, left: 0, bottom: 0, right: 0)
        self.tableView.contentInset = inset
        
        viewModel.newSelectedFood = []
    }
        
    func updateSubtitle()
    {
        let filteredSelectedFoodIds = viewModel.selectedFoodIds.filter(
            { (selectedFoodId) in
                viewModel.suggestedFood.contains(where: { $0.id == selectedFoodId })
            }
        )
        
        if viewModel.newSelectedFood.count > 0 || (viewModel.suggestedFood.count > 0 && filteredSelectedFoodIds.count > 0 && filteredSelectedFoodIds.count == viewModel.suggestedFood.count)
        {
            guard let reagentID = Reagent.ID(rawValue: reagentId ?? -1),
                  let reagentName = Reagents[reagentID]?.name else
            {
                assertionFailure("ReagentFoodViewController-updateSubtitle: Can't get reagent with id: \(reagentId ?? -1)")
                return
            }
            subtitleLabel.text = String(format: NSLocalizedString("Looks like you already added all the food for %@", comment: ""), reagentName)
        }
        else
        {
            subtitleLabel.text = NSLocalizedString("Choose up to 3 food to add to your plan:", comment: "")
        }
    }
    
    // MARK: - Actions
    @IBAction func onBack()
    {
        back()
    }
    
    @IBAction func onNext()
    {
        let filteredSelectedFoodIds = viewModel.selectedFoodIds.filter(
            { (selectedFoodId) in
                viewModel.suggestedFood.contains(where: { $0.id == selectedFoodId })
            }
        )

        if (viewModel.suggestedFood.count > 0 && filteredSelectedFoodIds.count > 0 && filteredSelectedFoodIds.count == viewModel.suggestedFood.count) || viewModel.newSelectedFood.count == 0
        {
            nextScreen()
        }
        else if viewModel.newSelectedFood.count > 0
        {
            nextButton.isEnabled = false
            nextButton.backgroundColor = Constants.vesselGray
            
            addFoodToPlan
            {
                self.nextButton.isEnabled = true
                self.nextButton.backgroundColor = Constants.vesselBlack
            }
        }
    }
}

extension ReagentFoodViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        viewModel.suggestedFood.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        guard let food = viewModel.suggestedFood[safe: indexPath.row] else
        {
            assertionFailure("ReagentFoodViewController-tableViewHeightForRowAt: Can't get suggestedFood at indexPath: \(indexPath)")
            return 0
        }
        if viewModel.selectedFoodIds.contains(food.id)
        {
            return 0.0
        }
        else
        {
            return 96.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReagentFoodCell", for: indexPath) as? ReagentFoodTableViewCell,
              let food = viewModel.suggestedFood[safe: indexPath.row],
              let imageURL = URL(string: food.imageUrl) else
        {
            assertionFailure("ReagentFoodViewController-tableViewCellForRowAt: Can't get cell, suggestedFood or imageURL at indexPath: \(indexPath)")
            return UITableViewCell()
        }
        
        var reagentQuantity = ""
        if food.quantity > 0
        {
            if food.quantity < 1
            {
                reagentQuantity = "\(Int(food.quantity * 1000))\(" μg")"
            }
            else
            {
                reagentQuantity = "\(Int(food.quantity))\(" mg")"
            }
        }
        
        let isChecked = viewModel.newSelectedFood.contains(food)
        cell.setup(foodName: food.foodTitle, reagentQuantity: reagentQuantity, isChecked: isChecked, backgroundImageURL: imageURL)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        guard let food = viewModel.suggestedFood[safe: indexPath.row] else
        {
            assertionFailure("ReagentFoodViewController-tableViewDidSelectRowAt: Can't get suggestedFood at indexPath: \(indexPath)")
            return
        }
        if let index = viewModel.newSelectedFood.firstIndex(of: food)
        {
            viewModel.newSelectedFood.remove(at: index)
        }
        else
        {
            if viewModel.newSelectedFood.count == 3
            {
                viewModel.newSelectedFood.remove(at: 0)
            }
            viewModel.newSelectedFood.append(food)
        }
        tableView.reloadData()
    }
}
