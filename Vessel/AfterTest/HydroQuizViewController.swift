//
//  HydroQuizViewController.swift
//  Vessel
//
//  Created by Nicolas Medina on 10/11/22.
//

import UIKit

class HydroQuizViewController: AfterTestMVVMViewController
{
    // MARK: - Views
    @IBOutlet private var optionViews: [UIView]!
    @IBOutlet private var checkmarkViews: [UIImageView]!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var titleStackViewVerticalSeparator: NSLayoutConstraint!
    @IBOutlet private weak var nextButton: BounceButton!
    
    // MARK: - UIViewController Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        for view in optionViews
        {
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onOptionTapped))
            view.addGestureRecognizer(gestureRecognizer)
        }
        
        if view.frame.height < Constants.SMALL_SCREEN_HEIGHT_THRESHOLD
        {
            titleLabel.font = Constants.FontTitleMain24
            titleStackViewVerticalSeparator.constant = 10
            view.layoutIfNeeded()
        }
        updateNextButton()
    }
    
    // MARK: - Actions
    @IBAction func onBack()
    {
        back()
    }
    
    @IBAction func onNext()
    {
        guard let selectedOption = viewModel.selectedWaterOption else
        {
            UIView.showError(text: "", detailText: NSLocalizedString("Please select an answer", comment: ""))
            return
        }
        switch selectedOption
        {
        case 0:
            viewModel.setDailyWaterIntake(dailyDrinkedGlasses: 2)
        case 1:
            viewModel.setDailyWaterIntake(dailyDrinkedGlasses: 4)
        case 2:
            viewModel.setDailyWaterIntake(dailyDrinkedGlasses: 8)
        case 3:
            viewModel.setDailyWaterIntake(dailyDrinkedGlasses: 12)
        default:
            break
        }
        nextScreen()
    }
    
    // MARK: - UI
    func updateNextButton()
    {
        if viewModel.selectedWaterOption != nil
        {
            nextButton.backgroundColor = Constants.vesselBlack
        }
        else
        {
            nextButton.backgroundColor = Constants.vesselGray
        }
    }
}

private extension HydroQuizViewController
{
    func reloadUI()
    {
        updateNextButton()
        for view in checkmarkViews
        {
            view.image = UIImage(named: "Checkbox_beige_unselected")
        }
        guard let selectedOption = viewModel.selectedWaterOption,
              let checkmarkView = checkmarkViews[safe: selectedOption] else
        {
            assertionFailure("HydroQuizViewController-reloadUI: Can't get selected option checkmark view")
            return
        }
        
        checkmarkView.image = UIImage(named: "Checkbox_beige_selected")
    }
    
    @objc
    func onOptionTapped(gestureRecognizer: UIGestureRecognizer)
    {
        guard let view = gestureRecognizer.view,
              let index = optionViews.firstIndex(of: view) else
        {
            assertionFailure("HydroQuizViewController-onOptionTapped: Can't get option view")
            return
        }
        if viewModel.selectedWaterOption == index
        {
            viewModel.selectedWaterOption = nil
        }
        else
        {
            viewModel.selectedWaterOption = index
        }
        reloadUI()
    }
}
