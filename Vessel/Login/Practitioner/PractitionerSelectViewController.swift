//
//  PractitionerSelectViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 2/23/23.
//

import UIKit

protocol PractitionerSelectViewControllerDelegate: AnyObject
{
    func showSplash()
}

class PractitionerSelectViewController: UIViewController, SelectionCheckmarkViewDelegate
{
    @Resolved internal var analytics: Analytics
    var viewModel: PractitionerQueryViewModel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var nextButton: UIButton!
    var delegate: PractitionerSelectViewControllerDelegate?
    
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
            selectionCheckmarkView.textLabel.text = "\(expert.first_name ?? "") \(expert.last_name ?? "")"
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
        //forces WelcomeSignInViewController to update splash screen in case co-branding changed
        delegate?.showSplash()
        
        //remove previous viewController
        guard let navigationController = self.navigationController else { return }
        var navigationArray = navigationController.viewControllers // To get all UIViewController stack as Array
        navigationArray.remove(at: navigationArray.count - 2) // To remove previous UIViewController
        self.navigationController?.viewControllers = navigationArray
        
        UserDefaults.standard.removeObject(forKey: Constants.KEY_PRL_NO_MATCH)
        navigationController.fadeOut()
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
