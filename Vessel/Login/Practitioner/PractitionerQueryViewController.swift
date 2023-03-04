//
//  PractitionerQueryViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 2/23/23.
//

import UIKit

class PractitionerQueryViewController: UIViewController, SelectionCheckmarkViewDelegate, VesselScreenIdentifiable, PractitionerQueryViewModelDelegate
{
    let flowName: AnalyticsFlowName = .practitionerQueryFlow
    @Resolved internal var analytics: Analytics
    @IBOutlet weak var yesButton: SelectionCheckmarkView!
    @IBOutlet weak var noButton: SelectionCheckmarkView!
    @IBOutlet weak var nextButton: LoadingButton!
    var viewModel = PractitionerQueryViewModel()
    var expertsAreLoaded = false
    var didTryToViewExperts = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        viewModel.delegate = self
        enableNextButton(false)
        yesButton.textLabel.text = NSLocalizedString("Yes", comment: "")
        noButton.textLabel.text = NSLocalizedString("No", comment: "")
        yesButton.delegate = self
        noButton.delegate = self
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("❇️ \(self)")
        }
    }
    
    deinit
    {
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("❌ \(self)")
        }
    }
    
    @IBAction func back()
    {
        navigationController?.fadeOut()
    }
    
    func enableNextButton(_ isEnabled: Bool)
    {
        nextButton.isEnabled = isEnabled
        if isEnabled
        {
            nextButton.backgroundColor = .black
        }
        else
        {
            nextButton.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
        }
    }
    
    func didTapCheckmark(_ checkmarkView: SelectionCheckmarkView, _ isChecked: Bool)
    {
        if checkmarkView == yesButton && isChecked == true
        {
            if noButton.isChecked == true
            {
                noButton.isChecked = false
            }
        }
        if checkmarkView == noButton && isChecked == true
        {
            if yesButton.isChecked == true
            {
                yesButton.isChecked = false
            }
        }
        if yesButton.isChecked == false && noButton.isChecked == false
        {
            enableNextButton(false)
        }
        else
        {
            enableNextButton(true)
        }
    }
    
    @IBAction func next()
    {
        if yesButton.isChecked
        {
            didTryToViewExperts = true
            if expertsAreLoaded == true
            {
                selectExpert()
            }
            else
            {
                nextButton.showLoading()
            }
        }
        else
        {
            //then no button is checked
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TestCardExistCheckingViewController") as! TestCardExistCheckingViewController
            self.navigationController?.pushViewController(vc, animated: true)
            self.nextButton.hideLoading()
        }
    }
    
    func selectExpert()
    {
        let vc = PractitionerSelectViewController.initWith(viewModel: viewModel)
        self.navigationController?.fadeTo(vc)
    }
    
    func expertsLoaded()
    {
        expertsAreLoaded = true
        if didTryToViewExperts == true
        {
            nextButton.hideLoading()
            selectExpert()
        }
    }
}
