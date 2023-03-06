//
//  PractitionerSelectViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 2/23/23.
//

import UIKit

class PractitionerSelectViewController: UIViewController, SelectionCheckmarkViewDelegate, VesselScreenIdentifiable
{
    let flowName: AnalyticsFlowName = .practitionerQueryFlow
    @Resolved internal var analytics: Analytics
    var viewModel: PractitionerQueryViewModel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var nextButton: UIButton!
    
    static func initWith(viewModel: PractitionerQueryViewModel) -> PractitionerSelectViewController
    {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PractitionerSelectViewController") as! PractitionerSelectViewController
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("❇️ \(self)")
        }
        enableNextButton(false)
        stackView.removeAllArrangedSubviews()
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
        let numExperts = viewModel.numExperts()
        
        for i in 0 ..< numExperts
        {
            let expert = viewModel.expertFor(index: i)
            
            let selectionCheckmarkView = SelectionCheckmarkView()
            selectionCheckmarkView.textLabel.text = "\(expert.last_name ?? ""), \(expert.first_name ?? "")"
            let heightConstraint = NSLayoutConstraint(item: selectionCheckmarkView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 72)
            selectionCheckmarkView.addConstraints([heightConstraint])
            selectionCheckmarkView.delegate = self
            stackView.addArrangedSubview(selectionCheckmarkView)
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
                        print("Selected Practitioner: \(index)")
                        viewModel.selectedPractitioner = index
                    }
                }
            }
            enableNextButton(true)
        }
        else
        {
            enableNextButton(false)
            print("Selected Practitioner: nil")
            viewModel.selectedPractitioner = nil
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
        viewModel.setExpertAssociation()
        
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TestCardExistCheckingViewController") as! TestCardExistCheckingViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /*
    //MARK: - TableView delegates
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 72.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return viewModel.numExperts()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PractitionerSelectCell", for: indexPath) as! PractitionerSelectCell
        
        let expertInfo = viewModel.expertFor(index: indexPath.row)
        cell.selectionCheckmarkView.textLabel.text = expertInfo.expert_name
        return cell
    }
     */
}
