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

class HeightWeightSelectViewController: KeyboardFriendlyViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource
{
    @IBOutlet weak var heightPickerView: UIPickerView!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var weightUnitsLabel: UILabel!
    var viewModel: OnboardingViewModel?
    var isMetric: Bool!
    
    private enum HeightComponentImperial: Int, CaseIterable
    {
        case feet
        case inches
    }
    
    private enum HeightComponentMetric: Int, CaseIterable
    {
        case centimeters
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //determine if we are using imperial or metric units
        let locale = Locale.current
        isMetric = locale.usesMetricSystem
        
        if isMetric
        {
            weightUnitsLabel.text = NSLocalizedString("Kg", comment: "Abbreviation for Kilograms")
            if let height_cm = viewModel?.userHeight
            {
                self.setHeightForPickerView(centimeters: Int(height_cm))
            }
            else
            {
                setHeightForPickerView(centimeters: Constants.DEFAULT_HEIGHT)
            }
        }
        else
        {
            if let height_cm = viewModel?.userHeight
            {
                let (feet, inches) = self.convertCentimetersToFeetInches(centimeters: height_cm)
                self.setHeightForPickerView(feet: feet, inches: inches)
            }
            else
            {
                let (feet, inches) = self.convertCentimetersToFeetInches(centimeters: Double(Constants.DEFAULT_HEIGHT))
                setHeightForPickerView(feet: feet, inches: inches)
            }
        }
        
        if let weight = UserDefaults.standard.string(forKey: Constants.KEY_DEFAULT_WEIGHT_LBS)
        {
            if isMetric
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
        if let weight = viewModel?.userWeight
        {
            if isMetric
            {
                let weightKG = weight * 0.45359237 // pounds to kilograms conversion
                weightTextField.text = "\(weightKG)" 
            }
            else
            {
                weightTextField.text = "\(weight)"
            }
        }
    }
    
    override func viewDidLayoutSubviews()
    {
        //change default gray selection color to white
        //if done in viewDidLoad, app could crash because subviews may not exist yet
        heightPickerView.subviews[1].backgroundColor = UIColor.white.withAlphaComponent(0.5)
    }
    
    func getSelections() -> Double
    {
        if isMetric
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
    
    private func convertCentimetersToFeetInches(centimeters: Double) -> (Int, Int)
    {
        let heightCentimeters = Measurement(value: centimeters, unit: UnitLength.centimeters)
        let heightFeet = heightCentimeters.converted(to: UnitLength.feet)
        let inches = Int((heightFeet.value - floor(heightFeet.value)) * 12)
        let feet = Int(heightFeet.value)
        return (feet, inches)
    }
    
    private func setHeightForPickerView(centimeters: Int)
    {
        if isMetric
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
        if !isMetric
        {
            heightPickerView.selectRow(feet, inComponent: HeightComponentImperial.feet.rawValue, animated: false)
            heightPickerView.selectRow(inches, inComponent: HeightComponentImperial.inches.rawValue, animated: false)
        }
    }
    
    @IBAction func back()
    {
        if let weight = weightTextField.text, weight.count != 0
        {
            viewModel?.setHeightWeight(height: getSelections(), weight: Double(weight)!)
        }
        viewModel?.backup()
        navigationController?.fadeOut()
    }
    
    @IBAction func next()
    {
        if let weight = weightTextField.text, weight.count != 0
        {
            viewModel?.setHeightWeight(height: getSelections(), weight: Double(weight)!)
            
            let vc = OnboardingViewModel.NextViewController()
            navigationController?.fadeTo(vc)
        }
        else
        {
            UIView.showError(text: "", detailText: NSLocalizedString("Please enter your weight", comment: ""))
        }
    }
    
    @IBAction func privacyPolicyButton()
    {
        openInSafari(url: Constants.privacyPolicyURL)
    }
    
    //MARK: - Picker delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if isMetric
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
        if isMetric
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
        if isMetric
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
    
    //MARK: - textfield delegates
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        return true
    }
    
    //MARK: - textfield delegates
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        self.activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        self.activeTextField = nil
    }
}
