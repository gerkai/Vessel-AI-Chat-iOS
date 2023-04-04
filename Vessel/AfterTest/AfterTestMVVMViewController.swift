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
    var viewModel: AfterTestViewModel!
    var transition: ScreenTransistion = .fade
    var backTransition: ScreenTransistion = .fade
    @Resolved var analytics: Analytics
    internal var isVisible = false
    
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

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        isVisible = true
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        isVisible = false
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
            let vc = GetSupplementsViewController.initWith(viewModel: viewModel, type: .buyFuel, delegate: self)
            setTransitionAndNavigate(vc: vc, transition: result.transition)
        }
        else if result.type == .ingredientsPrompt
        {
            let vc = GetSupplementsViewController.initWith(viewModel: viewModel, type: .showFormulation, delegate: self)
            setTransitionAndNavigate(vc: vc, transition: result.transition)
        }
        else if result.type == .ingredientsPromptWithoutFuel
        {
            let vc = GetSupplementsViewController.initWith(viewModel: viewModel, type: .showFormulationWithoutQuiz, delegate: self)
            setTransitionAndNavigate(vc: vc, transition: result.transition)
        }
        else if result.type == .dismiss
        {
            //also called in ResultsViewController
            PlansManager.shared.loadPlans() //so supplement card will appear if it wasn't previously shown
            NotificationCenter.default.post(name: .selectTabNotification, object: nil, userInfo: ["tab": Constants.TAB_BAR_RESULTS_INDEX])
            dismiss(animated: true)
            
            if !viewModel.hasSupplementPlan
            {
                let hasTakenQuiz = viewModel.hasTakenQuiz
                DispatchQueue.main.asyncAfter(deadline: .now() + Constants.AFTER_TEST_POP_UP_TIMEOUT, execute: {
                    guard let mainTabBarController = self.mainTabBarController else { return }
                    GenericAlertViewController.presentAlert(in: mainTabBarController,
                                                            type: .imageTitleSubtitleButtons(image: UIImage(named: "supplements")!,
                                                                                             title: GenericAlertLabelInfo(title: NSLocalizedString("Your personalized supplements are waiting", comment: ""),
                                                                                                                          font: Constants.FontTitleMain24,
                                                                                                                          height: 60.0),
                                                                                             subtitle: GenericAlertLabelInfo(title: hasTakenQuiz ? NSLocalizedString("You’ve already taken a quiz so your supplements formula is now finalized.", comment: "") : NSLocalizedString("The next step to your personalized supplements is a 3 minute quiz.", comment: ""),
                                                                                                                             alignment: .center,
                                                                                                                             height: 80.0),
                                                                                             buttons: [
                                                                                                GenericAlertButtonInfo(label: GenericAlertLabelInfo(title: hasTakenQuiz ? NSLocalizedString("Buy now", comment: "") : NSLocalizedString("Take the quiz", comment: "")), type: .dark),
                                                                                                GenericAlertButtonInfo(label: GenericAlertLabelInfo(title: NSLocalizedString("Learn more", comment: "")), type: .plain)
                                                                                             ]),
                                                            showCloseButton: true,
                                                            delegate: self)
                })
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

extension AfterTestMVVMViewController: GetSupplementsViewControllerDelegate
{
    func updateFuelState()
    {
        viewModel.loadFuelState { }
    }
}

extension AfterTestMVVMViewController: GenericAlertDelegate
{
    func onAlertButtonTapped(_ alert: GenericAlertViewController, index: Int, alertDescription: String)
    {
        if viewModel.hasTakenQuiz
        {
            showFormulation()
        }
        else
        {
            showSupplementQuiz()
        }
    }
    
    func showSupplementQuiz()
    {
        if let expertID = Contact.main()!.expert_id
        {
            ObjectStore.shared.get(type: Expert.self, id: expertID)
            { [weak self] expert in
                guard let self = self else { return }
                if let urlCode = expert.url_code
                {
                    let expertFuelQuizURL = Server.shared.ExpertFuelQuizURL(urlCode: urlCode)
                    self.showSupplementQuiz(path: expertFuelQuizURL)
                }
            }
            onFailure:
            { [weak self] in
                guard let self = self else { return }
                self.showSupplementQuiz(path: Server.shared.FuelQuizURL())
            }
        }
        else
        {
            showSupplementQuiz(path: Server.shared.FuelQuizURL())
        }
    }
    
    private func showSupplementQuiz(path: String)
    {
        analytics.log(event: .prlAfterTestGetSupplement(expertID: Contact.main()!.pa_id))
        Server.shared.multipassURL(path: path)
        { url in
            print("SUCCESS: \(url)")
            Log_Add("Supplement Quiz: \(url)")
            let vc = TodayWebViewController.initWith(url: url, delegate: self)
            if let mainTabBarController = self.mainTabBarController, !self.isVisible
            {
                mainTabBarController.present(vc, animated: true)
            }
            else
            {
                self.present(vc, animated: true)
            }
        }
        onFailure:
        { string in
            print("Failure: \(string)")
        }
    }
    
    func showFormulation()
    {
        analytics.log(event: .prlMoreTabShowIngredients(expertID: Contact.main()!.pa_id))
        Server.shared.multipassURL(path: Server.shared.FuelFormulationURL())
        { url in
            print("SUCCESS: \(url)")
            Log_Add("Formulation: \(url)")
            let vc = TodayWebViewController.initWith(url: url, delegate: self)
            if let mainTabBarController = self.mainTabBarController, !self.isVisible
            {
                mainTabBarController.present(vc, animated: true)
            }
            else
            {
                self.present(vc, animated: true)
            }
        }
        onFailure:
        { string in
            print("Failure: \(string)")
        }
    }
}

extension AfterTestMVVMViewController: TodayWebViewControllerDelegate
{
    func todayWebViewDismissed()
    {
        Contact.main()!.getFuel
        {
            PlansManager.shared.loadPlans()
        }
    }
}
