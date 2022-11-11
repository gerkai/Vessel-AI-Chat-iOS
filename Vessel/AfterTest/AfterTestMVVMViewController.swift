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
    case dismiss
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
    
    deinit
    {
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("📘 deinit \(self)")
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
    
    func nextScreen()
    {
        let result = viewModel.nextViewControllerData()
        if result.isHydroQuiz
        {
            let storyboard = UIStoryboard(name: "AfterTest", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HydroQuizViewController") as! HydroQuizViewController
            vc.viewModel = viewModel
            vc.transition = result.transition
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
        else if result.isReagentFood
        {
            let storyboard = UIStoryboard(name: "AfterTest", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ReagentFoodViewController") as! ReagentFoodViewController
            vc.viewModel = viewModel
            vc.titleText = result.title
            vc.reagentId = result.reagentId
            vc.transition = result.transition
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
        else if result.transition == .dismiss
        {
            //also called in ResultsViewController
            NotificationCenter.default.post(name: .selectTabNotification, object: nil, userInfo: ["tab": Constants.TAB_BAR_RESULTS_INDEX])
            dismiss(animated: true)
        }
        else
        {
            let vc = ReagentInfoViewController.initWith(viewModel: viewModel, result: result)
            vc.transition = result.transition
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
