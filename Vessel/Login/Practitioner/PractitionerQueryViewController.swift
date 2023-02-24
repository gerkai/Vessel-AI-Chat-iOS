//
//  PractitionerQueryViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 2/23/23.
//

import UIKit

protocol PractitionerQueryViewControllerDelegate: AnyObject
{
    func showSplash()
}

class PractitionerQueryViewController: UIViewController, SelectionCheckmarkViewDelegate, PractitionerSelectViewControllerDelegate
{
    @IBOutlet weak var yesButton: SelectionCheckmarkView!
    @IBOutlet weak var noButton: SelectionCheckmarkView!
    @IBOutlet weak var nextButton: UIButton!
    @Resolved internal var analytics: Analytics
    var viewModel = PractitionerQueryViewModel()
    var delegate: PractitionerQueryViewControllerDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
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
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let vc = PractitionerSelectViewController.initWith(viewModel: viewModel)
            vc.delegate = self
            self.navigationController?.fadeTo(vc)
        }
        else
        {
            //then no button is checked
            navigationController?.fadeOut()
        }
    }
    
    func showSplash()
    {
        //forces WelcomeSignInViewController to update splash screen in case co-branding changed
        delegate?.showSplash()
    }
}
