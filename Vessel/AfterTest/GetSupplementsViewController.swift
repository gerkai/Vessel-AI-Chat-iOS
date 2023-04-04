//
//  GetSupplementsViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 12/28/22.
//

import UIKit

enum GetSupplementsViewControllerType
{
    case buyFuel
    case showFormulationWithoutQuiz
    case showFormulation
}

protocol GetSupplementsViewControllerDelegate: AnyObject
{
    func updateFuelState()
}

class GetSupplementsViewController: AfterTestMVVMViewController
{
    @IBOutlet weak var getSupplementsButton: LoadingButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    private var type: GetSupplementsViewControllerType?
    
    weak var delegate: GetSupplementsViewControllerDelegate?
    
    static func initWith(viewModel: AfterTestViewModel, type: GetSupplementsViewControllerType, delegate: GetSupplementsViewControllerDelegate?) -> GetSupplementsViewController
    {
        let storyboard = UIStoryboard(name: "AfterTest", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GetSupplementsViewController") as! GetSupplementsViewController
        vc.viewModel = viewModel
        vc.type = type
        vc.delegate = delegate
        
        return vc
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupUI()
    }
    
    @IBAction func onBack()
    {
        back()
    }
    
    @IBAction func getSupplementPlan()
    {
        getSupplementsButton.showLoading()
        
        if type == .buyFuel
        {
            super.showSupplementQuiz()
        }
        else
        {
            showFormulation()
        }
    }
    
    @IBAction func maybeLater()
    {
        nextScreen()
    }
    
    private func setupUI()
    {
        guard let type = type else { return }
        switch type
        {
        case .buyFuel:
            titleLabel.text = NSLocalizedString("See what supplements can help you feel your best.", comment: "")
            descriptionLabel.text = NSLocalizedString("Take this simple 3 minute quiz and you'll get a personalized supplement plan based on your recent wellness test results and quiz answers. It's one of the perks of your Vessel membership.", comment: "")
            getSupplementsButton.setTitle(NSLocalizedString("Get Supplement Plan", comment: ""), for: .normal)
            
        case .showFormulation:
            titleLabel.text = NSLocalizedString("Your supplement formula is now complete", comment: "")
            descriptionLabel.text = NSLocalizedString("Now that you’ve taken a test we’re able to complete your formulation and will begin making it. We’re going to hand make your unique supplement just for you, so it should arrive in 2-3 weeks.", comment: "")
            getSupplementsButton.setTitle(NSLocalizedString("View Supplement Formula", comment: ""), for: .normal)
            
        case .showFormulationWithoutQuiz:
            titleLabel.text = NSLocalizedString("Your supplement formula is now complete", comment: "")
            descriptionLabel.text = NSLocalizedString("You can now review and purchase your personalized Fuel supplements. We hand make it jut for you so expect 10-14 days for delivery.", comment: "")
            getSupplementsButton.setTitle(NSLocalizedString("View Supplement Formula", comment: ""), for: .normal)
        }
    }
    
    override func todayWebViewDismissed()
    {
        Contact.main()!.getFuel
        { [weak self] in
            guard let self = self else { return }
            PlansManager.shared.loadPlans()
            self.delegate?.updateFuelState()
            if let mainTabBarController = self.mainTabBarController
            {
                if self.isVisible
                {
                    self.nextScreen()
                }
                else
                {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Constants.AFTER_TEST_POP_UP_TIMEOUT, execute: {
                        // User is already on the Today page
                        if let todayViewController = mainTabBarController.selectedViewController as? TodayViewController, mainTabBarController.selectedIndex == 0
                        {
                            todayViewController.presentSupplementsTutorial()
                        }
                        // User is on other tab
                        else
                        {
                            let vc = TodayTabPopupViewController.create()
                            mainTabBarController.present(vc, animated: false)
                        }
                    })
                }
            }
        }
    }
}
