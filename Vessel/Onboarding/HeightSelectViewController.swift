//
//  HeightSelectViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 3/5/22.
//

//TODO: Rename to HeightWeightSelectViewController. Also fix bug where screen doesn't return to original position after bringing up keyboard on non-home button devices.

import UIKit

class HeightSelectViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
    private enum HeightComponent: Int, CaseIterable
    {
        case feet
        case inches
    }
    
    @IBOutlet weak var heightPickerView: UIPickerView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let height_cm = Contact.main()?.height
        {
            let (feet, inches) = self.convertCentimetersToFeetInches(centimeters: height_cm)
            self.setHeightForPickerView(feet: feet, inches: inches)
        }
        else
        {
            setHeightForPickerView(feet: 5, inches: 0)
        }
        
        //change default gray selection color to white
        heightPickerView.subviews[1].backgroundColor = UIColor.white.withAlphaComponent(0.5)
    }
    
    func getSelections() -> Double
    {
        let feet = Double(heightPickerView.selectedRow(inComponent: HeightComponent.feet.rawValue))
        let inches = Double(heightPickerView.selectedRow(inComponent: HeightComponent.inches.rawValue))
        let feetCentimeters = Measurement(value: feet, unit: UnitLength.feet).converted(to: UnitLength.centimeters)
        let inchesCentimeters = Measurement(value: inches, unit: UnitLength.inches).converted(to: UnitLength.centimeters)
        let result = feetCentimeters + inchesCentimeters
        return result.value
    }
    
    private func convertCentimetersToFeetInches(centimeters: Double) -> (Int, Int)
    {
        let heightCentimeters = Measurement(value: centimeters, unit: UnitLength.centimeters)
        let heightFeet = heightCentimeters.converted(to: UnitLength.feet)
        let inches = Int((heightFeet.value - floor(heightFeet.value)) * 12)
        let feet = Int(heightFeet.value)
        return (feet, inches)
    }
    
    private func setHeightForPickerView(feet: Int, inches: Int)
    {
        heightPickerView.selectRow(feet, inComponent: HeightComponent.feet.rawValue, animated: false)
        heightPickerView.selectRow(inches, inComponent: HeightComponent.inches.rawValue, animated: false)
    }
    
    @IBAction func back()
    {
        navigationController?.fadeOut()
    }
    
    @IBAction func next()
    {
        if let contact = Contact.main()
        {
            contact.height = getSelections()
            ObjectStore.shared.ClientSave(contact)
        }
        let vc = OnboardingNextViewController()
        //{
            //navigationController?.pushViewController(vc, animated: true)
            navigationController?.fadeTo(vc)
        /*}
        else
        {
            self.navigationController?.popToRootViewController(animated: true)
            Server.shared.logOut()
        }*/
    }
    
    @IBAction func privacyPolicyButton()
    {
        openInSafari(url: Constants.privacyPolicyURL)
    }
    
    //MARK: - Picker delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        let heightComponent = HeightComponent(rawValue: component)
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        HeightComponent.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        let heightComponent = HeightComponent(rawValue: component)
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
