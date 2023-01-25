//
//  AfterTestMVVMViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/28/22.
//

import UIKit

enum ScreenTransistion
{
    case fade
    case push
}

class AfterTestMVVMViewController: UIViewController
{
    weak var viewModel: AfterTestViewModel!
    var transition: ScreenTransistion = .fade
    var backTransition: ScreenTransistion = .fade
    
    func initWithViewModel(vm: AfterTestViewModel)
    {
        self.viewModel = vm
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
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
    
    func back()
    {
        guard let viewControllersCount = navigationController?.viewControllers.count,
              let lastVC = navigationController?.viewControllers[safe: viewControllersCount - 2],
              lastVC.isMember(of: ReagentFoodViewController.self) == false
        else { return }
        
        viewModel.back()
        
        if backTransition == .push
        {
            navigationController?.popViewController(animated: true)
        }
        else
        {
            navigationController?.fadeOut()
        }
    }
    
    func setTransitionAndNavigate(vc: AfterTestMVVMViewController, transition: ScreenTransistion )
    {
        vc.transition = transition
        vc.backTransition = self.transition
        if transition == .fade
        {
            navigationController?.fadeTo(vc)
        }
        else
        {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func nextScreen()
    {
        let result = viewModel.nextViewControllerData()
        if result.type == .hydroQuiz
        {
            let storyboard = UIStoryboard(name: "AfterTest", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HydroQuizViewController") as! HydroQuizViewController
            vc.viewModel = viewModel
            setTransitionAndNavigate(vc: vc, transition: result.transition)
        }
        else if result.type == .reagentFood
        {
            let storyboard = UIStoryboard(name: "AfterTest", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ReagentFoodViewController") as! ReagentFoodViewController
            vc.viewModel = viewModel
            vc.titleText = result.title
            vc.reagentId = result.reagentId
            setTransitionAndNavigate(vc: vc, transition: result.transition)
        }
        else if result.type == .reagentInfo
        {
            let vc = ReagentInfoViewController.initWith(viewModel: viewModel, result: result)
            setTransitionAndNavigate(vc: vc, transition: result.transition)
        }
        else if result.type == .fuelPrompt
        {
            let vc = GetSupplementsViewController.initWith(viewModel: viewModel)
            setTransitionAndNavigate(vc: vc, transition: result.transition)
        }
        else if result.type == .dismiss
        {
            //also called in ResultsViewController
            PlansManager.shared.loadPlans() //so supplement card will appear if it wasn't previously shown
            NotificationCenter.default.post(name: .selectTabNotification, object: nil, userInfo: ["tab": Constants.TAB_BAR_RESULTS_INDEX])
            dismiss(animated: true)
        }
    }
    
    func addFoodsToPlan(onComplete complete: @escaping () -> Void)
    {
        viewModel.addFoodsToPlan
        { [weak self] in
            self?.nextScreen()
            complete()
        } onFailure: { error in
            UIView.showError(text: "", detailText: error)
            complete()
        }
    }
}
