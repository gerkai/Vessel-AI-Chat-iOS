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
    
    func back()
    {
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
        if result.transition == .dismiss
        {
            dismiss(animated: true)
        }
        else
        {
            let storyboard = UIStoryboard(name: "AfterTest", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ReagentInfoViewController") as! ReagentInfoViewController
            vc.viewModel = viewModel
            vc.titleText = result.title
            vc.details = result.details
            vc.image = UIImage.init(named: result.imageName)
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
    
    deinit
    {
        print("📘 deinit \(self)")
    }
}
