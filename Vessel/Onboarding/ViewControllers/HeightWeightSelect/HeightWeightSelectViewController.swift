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

class HeightWeightSelectViewController: KeyboardFriendlyViewController
{
    // MARK: - Views
    @IBOutlet private weak var heightPickerView: UIPickerView!
    @IBOutlet private weak var weightTextField: UITextField!
    @IBOutlet private weak var weightUnitsLabel: UILabel!
    
    // MARK: - Logic
    var viewModel = HeightWeightSelectViewModel()
    var coordinator: OnboardingCoordinator?

    // MARK: - ViewController Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print("📗 did load \(self)")
        setupUI()
    }
    
    deinit
    {
        print("📘 deinit \(self)")
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        // TODO: Add analytics for viewed page
    }
    
    override func viewDidLayoutSubviews()
    {
        //change default gray selection color to white
        //if done in viewDidLoad, app could crash because subviews may not exist yet
        heightPickerView.subviews[1].backgroundColor = UIColor.white.withAlphaComponent(0.5)
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
                    let weightKG = weightLbs * 0.45359237 // pounds to kilograms conversion
                    
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
                let weightKG = weight * 0.45359237 // pounds to kilograms conversion
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
            if centimeters >= Constants.MIN_HEIGHT_METRIC &&
                centimeters <= Constants.MAX_HEIGHT_METRIC
            {
                heightPickerView.selectRow(centimeters - Constants.MIN_HEIGHT_METRIC, inComponent: HeightComponentMetric.centimeters.rawValue, animated: false)
            }
        }
    }
    
    private func setHeightForPickerView(feet: Int, inches: Int)
    {
        if !viewModel.isMetric
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
        if let weight = weightTextField.text, weight.count != 0
        {
            viewModel.setHeightWeight(height: getSelections(), weight: Double(weight)!)
            
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
        if viewModel.isMetric
        {
            return String(format: NSLocalizedString("%i cm", comment: "abbreviation for height in 'centimeters'"), row + Constants.MIN_HEIGHT_METRIC)
        }
        else
        {
            let heightComponent = HeightComponentImperial(rawValue: component)
            switch heightComponent
            {
                case .feet:
                    return String(format: NSLocalizedString("%i ft", comment: "abbreviation for height in 'feet'"), row)
                case .inches:
                    return String(format: NSLocalizedString("%i in", comment: "abbreviation for height in 'inches'"), row)
                default:
                    return ""
            }
        }
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
            //let (maxFeet, maxInches) = self.convertCentimetersToFeetInches(centimeters: Double(Constants.MAX_HEIGHT_METRIC))
            //let (minFeet, minInches) = self.convertCentimetersToFeetInches(centimeters: Double(Constants.MIN_HEIGHT_METRIC))
            //print("MAX: \(maxFeet), \(maxInches)")
            //print("MIN: \(minFeet), \(minInches)")
            let heightComponent = HeightComponentImperial(rawValue: component)
            switch heightComponent
            {
                case .feet:
                    return 10
                case .inches:
                    return 12
                default:
                    return 0
            }
        }
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
        self.activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        self.activeTextField = nil
    }
}
