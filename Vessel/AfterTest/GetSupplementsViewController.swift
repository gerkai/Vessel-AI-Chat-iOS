//
//  GetSupplementsViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 12/28/22.
//

import UIKit

class GetSupplementsViewController: AfterTestMVVMViewController, TodayWebViewControllerDelegate
{
    @Resolved private var analytics: Analytics
    @IBOutlet weak var getSupplementsButton: LoadingButton!
    
    static func initWith(viewModel: AfterTestViewModel) -> GetSupplementsViewController
    {
        let storyboard = UIStoryboard(name: "AfterTest", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GetSupplementsViewController") as! GetSupplementsViewController
        vc.viewModel = viewModel
        
        return vc
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBAction func onBack()
    {
        back()
    }
    
    @IBAction func getSupplementPlan()
    {
        getSupplementsButton.showLoading()
        analytics.log(event: .prlAfterTestGetSupplement(expertID: Contact.main()!.pa_id))
        Server.shared.multipassURL(path: Server.shared.FuelQuizURL())
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
}

