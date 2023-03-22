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

class GetSupplementsViewController: AfterTestMVVMViewController, TodayWebViewControllerDelegate
{
    @Resolved private var analytics: Analytics
    @IBOutlet weak var getSupplementsButton: LoadingButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    private var type: GetSupplementsViewControllerType?

    static func initWith(viewModel: AfterTestViewModel, type: GetSupplementsViewControllerType) -> GetSupplementsViewController
    {
        let storyboard = UIStoryboard(name: "AfterTest", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GetSupplementsViewController") as! GetSupplementsViewController
        vc.viewModel = viewModel
        vc.type = type
        
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
            showSupplementQuiz()
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
    
    func todayWebViewDismissed()
    {
        Contact.main()!.getFuel
        {
            PlansManager.shared.loadPlans()
        }
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
    
    private func showSupplementQuiz()
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
            //self.openInSafari(url: url)
            Log_Add("Supplement Quiz: \(url)")
            let vc = TodayWebViewController.initWith(url: url, delegate: self)
            self.present(vc, animated: true)
            self.getSupplementsButton.hideLoading()
        }
        onFailure:
        { string in
            print("Failure: \(string)")
            self.getSupplementsButton.hideLoading()
        }
    }
    
    private func showFormulation()
    {
        analytics.log(event: .prlMoreTabShowIngredients(expertID: Contact.main()!.pa_id))
        Server.shared.multipassURL(path: Server.shared.FuelFormulationURL())
        { url in
            print("SUCCESS: \(url)")
            let vc = TodayWebViewController.initWith(url: url, delegate: self)
            self.present(vc, animated: true)
        }
        onFailure:
        { string in
            print("Failure: \(string)")
        }
    }
}

