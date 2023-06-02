//
//  StaffSelectViewController.swift
//  Vessel
//
//  Created by Nicolas Medina on 5/31/23.
//

import UIKit

class StaffSelectViewController: KeyboardFriendlyViewController, SelectionCheckmarkViewDelegate, VesselScreenIdentifiable, UITextFieldDelegate
{
    let flowName: AnalyticsFlowName = .practitionerQueryFlow
    @Resolved internal var analytics: Analytics
    let viewModel = StaffSelectViewModel()
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var nextButton: LoadingButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("❇️ \(self)")
        }
        enableNextButton(false)
        setupStackView()
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
    
    func setupStackView()
    {
        DispatchQueue.main.async
        {
            let numStaff = self.viewModel.staff.count
            self.stackView.removeAllArrangedSubviews()
            
            for i in 0 ..< numStaff
            {
                guard let staff = self.viewModel.staff[safe: i] else { return }
                
                let selectionCheckmarkView = SelectionCheckmarkView()
                if let lastName = staff.last_name
                {
                    selectionCheckmarkView.textLabel.text = "\(lastName), \(staff.first_name ?? "")"
                }
                else
                {
                    selectionCheckmarkView.textLabel.text = "\(staff.first_name ?? "")"
                }
                let heightConstraint = NSLayoutConstraint(item: selectionCheckmarkView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 72)
                selectionCheckmarkView.addConstraints([heightConstraint])
                selectionCheckmarkView.delegate = self
                self.stackView.addArrangedSubview(selectionCheckmarkView)
            }
        }
    }
    
    //MARK: - SelectionCheckmarkView Delegates
    func didTapCheckmark(_ checkmarkView: SelectionCheckmarkView, _ isChecked: Bool)
    {
        if isChecked == true
        {
            //uncheck any other checked items
            for index in 0 ..< stackView.arrangedSubviews.count
            {
                if let selView = stackView.arrangedSubviews[index] as? SelectionCheckmarkView
                {
                    if selView.isChecked == true && selView != checkmarkView
                    {
                        selView.isChecked = false
                    }
                    if selView == checkmarkView
                    {
                        print("Selected Staff: \(index)")
                        viewModel.selectedStaff = index
                    }
                }
            }
            enableNextButton(true)
        }
        else
        {
            enableNextButton(false)
            print("Selected Practitioner: nil")
            viewModel.selectedStaff = nil
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
    
    @IBAction func next()
    {
        nextButton.showLoading()
        viewModel.setSelectedStaff
        {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TestCardExistCheckingViewController") as! TestCardExistCheckingViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }       
    }
}
