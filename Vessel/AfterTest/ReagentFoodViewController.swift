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
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var nextButton: BounceButton!
    
    var titleText: String!
    var reagentId: Int?
    
    // MARK: - UIView Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if let reagentId = reagentId
        {
            viewModel.loadFoodsForReagent(reagentId: reagentId)
            { [weak self] in
                guard let self = self else { return }
                self.tableView.reloadData()
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
    }
    
    // MARK: - UI
    func updateNextButton()
    {
        if viewModel.selectedFoods.count > 0
        {
            nextButton.backgroundColor = Constants.vesselBlack
        }
        else
        {
            nextButton.backgroundColor = Constants.vesselGray
        }
    }
    
    // MARK: - Actions
    @IBAction func onBack()
    {
        back()
    }
    
    @IBAction func onNext()
    {
        if viewModel.selectedFoods.count > 0
        {
            nextButton.isEnabled = false
            nextButton.backgroundColor = Constants.vesselGray

            addFoodsToPlan
            {
                self.nextButton.isEnabled = true
                self.nextButton.backgroundColor = Constants.vesselBlack
            }
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
        return 96.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReagentFoodCell", for: indexPath) as? ReagentFoodTableViewCell,
              let food = viewModel.suggestedFoods[safe: indexPath.row],
              let imageURL = URL(string: food.imageUrl) else { return UITableViewCell() }
        let isChecked = viewModel.selectedFoods.contains(food)
        cell.setup(foodName: food.foodTitle, isChecked: isChecked, backgroundImageURL: imageURL)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        guard let food = viewModel.suggestedFoods[safe: indexPath.row] else { return }
        if let index = viewModel.selectedFoods.firstIndex(of: food)
        {
            viewModel.selectedFoods.remove(at: index)
        }
        else
        {
            if viewModel.selectedFoods.count == 3
            {
                viewModel.selectedFoods.remove(at: 0)
            }
            viewModel.selectedFoods.append(food)
        }
        tableView.reloadData()
        updateNextButton()
    }
}
