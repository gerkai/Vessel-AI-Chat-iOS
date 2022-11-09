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
        subtitleLabel.text = ""
        if let reagentId = reagentId
        {
            viewModel.loadFoodsForReagent(reagentId: reagentId)
            { [weak self] in
                guard let self = self else { return }
                self.tableView.reloadData()
                self.updateSubtitle()
                self.updateNextButton()
            }
            onFailure:
            { error in
                UIView.showError(text: "", detailText: error)
            }
        }
        titleLabel.text = titleText
        let inset = UIEdgeInsets(top: 28, left: 0, bottom: 0, right: 0)
        self.tableView.contentInset = inset
        
        updateNextButton()
        viewModel.newSelectedFoods = []
    }
    
    // MARK: - UI
    func updateNextButton()
    {
        let filteredSelectedFoodIds = viewModel.selectedFoodIds.filter(
            { (selectedFoodId) in
                viewModel.suggestedFoods.contains(where: { $0.id == selectedFoodId })
            }
        )
        
        if viewModel.newSelectedFoods.count > 0 || (viewModel.suggestedFoods.count > 0 && filteredSelectedFoodIds.count > 0 && filteredSelectedFoodIds.count == viewModel.suggestedFoods.count)
        {
            nextButton.backgroundColor = Constants.vesselBlack
        }
        else
        {
            nextButton.backgroundColor = Constants.vesselGray
        }
    }
    
    func updateSubtitle()
    {
        let filteredSelectedFoodIds = viewModel.selectedFoodIds.filter(
            { (selectedFoodId) in
                viewModel.suggestedFoods.contains(where: { $0.id == selectedFoodId })
            }
        )
        
        if viewModel.newSelectedFoods.count > 0 || (viewModel.suggestedFoods.count > 0 && filteredSelectedFoodIds.count > 0 && filteredSelectedFoodIds.count == viewModel.suggestedFoods.count)
        {
            guard let reagentID = Reagent.ID(rawValue: reagentId ?? -1),
                  let reagentName = Reagents[reagentID]?.name else { return }
            subtitleLabel.text = "Looks like you already added all the foods for \(reagentName)"
        }
        else
        {
            subtitleLabel.text = "Choose up to 3 foods to add to your plan:"
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
                viewModel.suggestedFoods.contains(where: { $0.id == selectedFoodId })
            }
        )

        if viewModel.newSelectedFoods.count > 0
        {
            nextButton.isEnabled = false
            nextButton.backgroundColor = Constants.vesselGray

            addFoodsToPlan
            {
                self.nextButton.isEnabled = true
                self.nextButton.backgroundColor = Constants.vesselBlack
            }
        }
        else if (viewModel.suggestedFoods.count > 0 && filteredSelectedFoodIds.count > 0 && filteredSelectedFoodIds.count == viewModel.suggestedFoods.count)
        {
            nextScreen()
        }
        else
        {
            UIView.showError(text: "", detailText: NSLocalizedString("Please select at least one food", comment: ""))
        }
    }
}

extension ReagentFoodViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        viewModel.suggestedFoods.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        guard let food = viewModel.suggestedFoods[safe: indexPath.row] else { return 0 }
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
              let food = viewModel.suggestedFoods[safe: indexPath.row],
              let imageURL = URL(string: food.imageUrl) else { return UITableViewCell() }
        let isChecked = viewModel.newSelectedFoods.contains(food)
        cell.setup(foodName: food.foodTitle, isChecked: isChecked, backgroundImageURL: imageURL)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        guard let food = viewModel.suggestedFoods[safe: indexPath.row] else { return }
        if let index = viewModel.newSelectedFoods.firstIndex(of: food)
        {
            viewModel.newSelectedFoods.remove(at: index)
        }
        else
        {
            if viewModel.newSelectedFoods.count == 3
            {
                viewModel.newSelectedFoods.remove(at: 0)
            }
            viewModel.newSelectedFoods.append(food)
        }
        tableView.reloadData()
        updateNextButton()
    }
}
