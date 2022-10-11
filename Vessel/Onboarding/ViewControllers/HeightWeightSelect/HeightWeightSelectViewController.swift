//
//  HeightWeightSelectViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 3/5/22.
//  Based on Onboarding Flow: https://www.notion.so/vesselhealth/Onboarding-79efd903aaf349098bf4e972bd9292cb
//
//  A BOOL, isMetric is initialized in viewDidLoad. It is used when deciding whether to present picker and weight
//  in imperial units or metric units.

import UIKit

class HeightWeightSelectViewController: KeyboardFriendlyViewController, VesselScreenIdentifiable
{
    // MARK: - Views
    @IBOutlet private weak var heightPickerView: UIPickerView!
    @IBOutlet private weak var weightTextField: UITextField!
    @IBOutlet private weak var weightUnitsLabel: UILabel!
    
    // MARK: - Logic
    var viewModel = HeightWeightSelectViewModel()
    var coordinator: OnboardingCoordinator?
    
    @Resolved internal var analytics: Analytics
    let flowName: AnalyticsFlowName = .onboardingFlow
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("📗 did load \(self)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    deinit
    {
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("📘 deinit \(self)")
        }
    }
    
    override func viewDidLayoutSubviews()
    {
        //hide default gray selection color
        //if done in viewDidLoad, app could crash because subviews may not exist yet
        heightPickerView.subviews[1].isHidden = true
    }
    
    // MARK: - UI
    func setupUI()
    {
        let height_cm = viewModel.userHeight
        if viewModel.isMetric
        {
            weightUnitsLabel.text = NSLocalizedString("Kg", comment: "Abbreviation for Kilograms")
            self.setHeightForPickerView(centimeters: Int(height_cm))
        }
        else
        {
            let (feet, inches) = viewModel.convertCentimetersToFeetInches(centimeters: height_cm)
            self.setHeightForPickerView(feet: feet, inches: inches)
        }
        
        if let weight = UserDefaults.standard.string(forKey: Constants.KEY_DEFAULT_WEIGHT_LBS)
        {
            if viewModel.isMetric
            {
                if let weightLbs = Double(weight)
                {
                    let weightKG = viewModel.convertLbsToKg(lbs: weightLbs)
                    
                    weightTextField.text = String(format: "%.1f", weightKG)
                }
            }
            else
            {
                weightTextField.text = weight
            }
        }
        
        //if we had previously chosen a weight on this screen then use that value instead
        if let weight = viewModel.userWeight
        {
            if viewModel.isMetric
            {
                let weightKG = viewModel.convertLbsToKg(lbs: weight)
                weightTextField.text = String(format: "%.1f", weightKG)
            }
            else
            {
                weightTextField.text = "\(weight)"
            }
        }
    }
    
    private func getSelections() -> Double
    {
        if viewModel.isMetric
        {
            let centimeters = Double(heightPickerView.selectedRow(inComponent: HeightComponentMetric.centimeters.rawValue) + Constants.MIN_HEIGHT_METRIC)
            return centimeters
        }
        else
        {
            let feet = Double(heightPickerView.selectedRow(inComponent: HeightComponentImperial.feet.rawValue))
            let inches = Double(heightPickerView.selectedRow(inComponent: HeightComponentImperial.inches.rawValue))
            let feetCentimeters = Measurement(value: feet, unit: UnitLength.feet).converted(to: UnitLength.centimeters)
            let inchesCentimeters = Measurement(value: inches, unit: UnitLength.inches).converted(to: UnitLength.centimeters)
            let result = feetCentimeters + inchesCentimeters
            return result.value
        }
    }
    
    private func setHeightForPickerView(centimeters: Int)
    {
        if viewModel.isMetric
        {
            if centimeters < Constants.MIN_HEIGHT_METRIC
            {
                heightPickerView.selectRow(Constants.MIN_HEIGHT_METRIC - Constants.MIN_HEIGHT_METRIC, inComponent: HeightComponentMetric.centimeters.rawValue, animated: false)
            }
            else if centimeters > Constants.MAX_HEIGHT_METRIC
            {
                heightPickerView.selectRow(Constants.MAX_HEIGHT_METRIC - Constants.MIN_HEIGHT_METRIC, inComponent: HeightComponentMetric.centimeters.rawValue, animated: false)
            }
            else
            {
                heightPickerView.selectRow(centimeters - Constants.MIN_HEIGHT_METRIC, inComponent: HeightComponentMetric.centimeters.rawValue, animated: false)
            }
        }
    }
    
    private func setHeightForPickerView(feet: Int, inches: Int)
    {
        let (maxFeet, maxInches) = viewModel.convertCentimetersToFeetInches(centimeters: Double(Constants.MAX_HEIGHT_METRIC))
        let (minFeet, minInches) = viewModel.convertCentimetersToFeetInches(centimeters: Double(Constants.MIN_HEIGHT_METRIC))
        
        if feet <= minFeet && inches < minInches
        {
            heightPickerView.selectRow(2, inComponent: HeightComponentImperial.feet.rawValue, animated: false)
            heightPickerView.selectRow(0, inComponent: HeightComponentImperial.inches.rawValue, animated: false)
        }
        else if feet >= maxFeet && inches > maxInches
        {
            heightPickerView.selectRow(9, inComponent: HeightComponentImperial.feet.rawValue, animated: false)
            heightPickerView.selectRow(11, inComponent: HeightComponentImperial.inches.rawValue, animated: false)
        }
        else if !viewModel.isMetric
        {
            heightPickerView.selectRow(feet, inComponent: HeightComponentImperial.feet.rawValue, animated: false)
            heightPickerView.selectRow(inches, inComponent: HeightComponentImperial.inches.rawValue, animated: false)
        }
    }
    
    // MARK: - Actions
    @IBAction func onBackTapped()
    {
        if let weight = weightTextField.text, weight.count != 0
        {
            viewModel.setHeightWeight(height: getSelections(), weight: Double(weight)!)
        }
        coordinator?.backup()
    }
    
    @IBAction func onNextTapped()
    {
        if let weightString = weightTextField.text, !weightString.isEmpty
        {
            guard let weight = Double(weightString) else
            {
                UIView.showError(text: "", detailText: NSLocalizedString("Please enter a valid weight", comment: ""))
                return
            }
            viewModel.setHeightWeight(height: getSelections(), weight: weight)
            
            coordinator?.pushNextViewController()
        }
        else
        {
            UIView.showError(text: "", detailText: NSLocalizedString("Please enter your weight", comment: ""))
        }
    }
    
    @IBAction func onPrivacyPolicyTapped()
    {
        openInSafari(url: Constants.privacyPolicyURL)
    }
}

//MARK: - Picker Delegate
extension HeightWeightSelectViewController: UIPickerViewDelegate, UIPickerViewDataSource
{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return viewModel.textFor(row: row, inComponent: component)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        if viewModel.isMetric
        {
            return HeightComponentMetric.allCases.count
        }
        else
        {
            return HeightComponentImperial.allCases.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if viewModel.isMetric
        {
            return Constants.MAX_HEIGHT_METRIC - Constants.MIN_HEIGHT_METRIC
        }
        else
        {
            let (maxFeet, _) = viewModel.convertCentimetersToFeetInches(centimeters: Double(Constants.MAX_HEIGHT_METRIC))
            let (minFeet, _) = viewModel.convertCentimetersToFeetInches(centimeters: Double(Constants.MIN_HEIGHT_METRIC))
            let heightComponent = HeightComponentImperial(rawValue: component)
            switch heightComponent
            {
                case .feet:
                    return maxFeet - minFeet + 1
                case .inches:
                    return 12
                default:
                    return 0
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString?
    {
        let string = viewModel.textFor(row: row, inComponent: component)
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    }
}

//MARK: - TextField Delegate
extension HeightWeightSelectViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        self.activeTextField = nil
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        guard !(textField.text ?? "").contains(".") || string != "." else { return false }
        let characterSet = NSCharacterSet(charactersIn: "0123456789.").inverted
        return string == string.components(separatedBy: characterSet).joined(separator: "")
    }
}
