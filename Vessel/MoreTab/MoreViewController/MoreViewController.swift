//
//  MoreViewController.swift
//  Vessel
//
//  Created by Nicolas Medina on 7/25/22.
//

import UIKit
import MessageUI

class MoreViewController: UIViewController, VesselScreenIdentifiable, DebugMenuViewControllerDelegate, MFMailComposeViewControllerDelegate
{
    // MARK: Views
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var versionLabel: UILabel!
    @IBOutlet private weak var environmentLabel: UILabel!
    @IBOutlet private weak var qrImageView: UIImageView!
    @IBOutlet private weak var companyNameLabel: UILabel!
    @IBOutlet private weak var practitionerView: UIView!
    
    @Resolved internal var analytics: Analytics
    let flowName: AnalyticsFlowName = .moreTabFlow
    
    // MARK: Model
    private let viewModel = MoreViewModel()
    private var practitionerName: String?
    private var practitionerDownloadURL: String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        versionLabel.text = viewModel.versionString
        environmentLabel.text = environment()
        if UserDefaults.standard.bool(forKey: Constants.KEY_DEBUG_MENU) == true
        {
            viewModel.addDebugMenu()
            tableView.reloadData()
        }
        if UserDefaults.standard.bool(forKey: Constants.KEY_DEBUG_LOG) == true
        {
            viewModel.addDebugLog()
            tableView.reloadData()
        }
        self.companyNameLabel.text = ""
        if viewModel.shouldShowPractitionerSection()
        {
            viewModel.practitionerInfo
            { name, qrString in
                self.practitionerName = name
                self.practitionerDownloadURL = qrString
                self.companyNameLabel.text = name
                self.qrImageView.image = self.createQR(qrString)
                self.practitionerView.isHidden = false
            }
            onFailure:
            {
                self.practitionerView.isHidden = true
            }
        }
        else
        {
            practitionerView.isHidden = true
        }
    }
    
    func createQR(_ string: String) -> UIImage?
    {
        let data = string.data(using: String.Encoding.ascii)
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else
        {
            return nil
        }
        qrFilter.setValue(data, forKey: "inputMessage")
        guard let qrImage = qrFilter.outputImage else
        {
            return nil
        }
        
        // Scale the image
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledQrImage = qrImage.transformed(by: transform)
        
        // Get a CIContext
        let context = CIContext()
        // Create a CGImage *from the extent of the outputCIImage*
        guard let processedImage = context.createCGImage(scaledQrImage, from: scaledQrImage.extent) else { return nil }
        // Finally, get a usable UIImage from the CGImage
        let convertedImage = UIImage(cgImage: processedImage)
        return convertedImage
    }
    
    func environment() -> String
    {
        let index = UserDefaults.standard.integer(forKey: Constants.environmentKey)
        switch index
        {
            case Constants.DEV_INDEX:
                return "Dev Environment"
            case Constants.STAGING_INDEX:
                return "Staging Environment"
            default:
                return ""
        }
    }
    
    // MARK: - Actions
    @IBAction func onLeftButton()
    {
        viewModel.key.append(0)
        viewModel.key.remove(at: 0)
    }
    
    @IBAction func onRightButton()
    {
        viewModel.key.append(1)
        viewModel.key.remove(at: 0)
    }
    
    @IBAction func onMailButton()
    {
        if MFMailComposeViewController.canSendMail()
        {
            if let qrString = practitionerDownloadURL
            {
                let messageBody = NSLocalizedString("Tap on this link to download the Vessel Wellness app\n\n", comment: "") + qrString
                
                let mailComposer = MFMailComposeViewController()
                mailComposer.mailComposeDelegate = self
                mailComposer.setSubject(NSLocalizedString("Vessel Wellness App", comment: "email subject line"))
                //mailComposer.setToRecipients([MAIL_RECIPIENT])
                mailComposer.setMessageBody(messageBody, isHTML: false)
                mailComposer.modalPresentationStyle = .fullScreen
                present(mailComposer, animated: true)
            }
        }
        else
        {
            let alertController = UIAlertController(title: "Debug Log", message: "E-mail is not currently available for this device", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default)
            { (action) in
                //print("You've pressed cancel");
                self.dismiss(animated: true, completion: nil)
            }
            
            alertController.addAction(okAction)
            present(alertController, animated: true)
        }
    }
    
    @IBAction func onShareButton()
    {
        if let qrString = practitionerDownloadURL
        {
            let messageBody = NSLocalizedString("Tap on this link to download the Vessel Wellness app\n\n", comment: "") + qrString
            
            //let objectsToShare = [messageBody, myWebsiteURL, image ?? #imageLiteral(resourceName: "app-logo")] as [Any]
            let objectsToShare = [messageBody] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //Excluded Activities
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            
            activityVC.popoverPresentationController?.sourceView = self.view
            present(activityVC, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        switch result
        {
            case .cancelled:
                print("Mail cancelled")
            case .saved:
                print("Mail saved")
            case .sent:
                print("Mail sent")
            case .failed:
                print("Mail sent failure: %@", error!.localizedDescription)
            if let description = error?.localizedDescription
            {
                UIView.showError(text: NSLocalizedString("Couldn't send mail", comment: ""), detailText: description, image: nil)
            }
            default:
                break
        }
        controller.dismiss(animated: true)
    }
}

extension MoreViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return viewModel.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let option = viewModel.options[safe: indexPath.row],
              let cell = tableView.dequeueReusableCell(withIdentifier: "MoreTabCell", for: indexPath) as? MoreTabCell else
        {
            assertionFailure("MoreTabCell dequed in a bad state in MoreViewController cellForRowAt indexPath")
            return UITableViewCell()
        }
        cell.setup(title: option.text, iconName: option.icon)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80.0
    }
}

extension MoreViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        guard let option = viewModel.options[safe: indexPath.row] else
        {
            assertionFailure("MoreTabCell dequed in a bad state in MoreViewController didSelectRowAt indexPath")
            return
        }
        
        switch option
        {
        case .myAccount:
            let storyboard = UIStoryboard(name: "MoreTab", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "MyAccountViewController") as! MyAccountViewController
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case .takeATest:
            mainTabBarController?.vesselButtonPressed()
        case .orderCards:
            openInSafari(url: "https://vesselhealth.com/membership")
        case .customSupplements:
            if let fuel = Contact.FuelInfo
            {
                if fuel.is_active
                {
                    openFormulation()
                }
                else
                {
                    openSupplementQuiz()
                }
            }
            else
            {
                openSupplementQuiz()
            }
        case .chatWithNutritionist:
            tabBarController?.selectedIndex = Constants.TAB_BAR_COACH_INDEX
        case .backedByScience:
            openInSafari(url: "https://vesselhealth.com/pages/backed-by-science")
        case .support:
            if viewModel.key == viewModel.debugMenuLock && !viewModel.options.contains(.debug)
            {
                viewModel.addDebugMenu()
                tableView.reloadData()
            }
            else if viewModel.key == viewModel.debugLogLock
            {
                if viewModel.options.contains(.debugLog)
                {
                    viewModel.removeDebugLog()
                }
                else
                {
                    viewModel.addDebugLog()
                }
                tableView.reloadData()
            }
            else
            {
                openInSafari(url: Constants.zenDeskSupportURL)
            }
        case .debug:
            let storyboard = UIStoryboard(name: "MoreTab", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "DebugMenuViewController") as! DebugMenuViewController
            vc.hidesBottomBarWhenPushed = false
            vc.delegate = self
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.pushViewController(vc, animated: true)
        case .debugLog:
            let storyboard = UIStoryboard(name: "MoreTab", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "LogViewController") as! LogViewController
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func refresh()
    {
        viewModel.removeDebugMenu()
        tableView.reloadData()
    }
    
    private func openSupplementQuiz()
    {
        analytics.log(event: .prlMoreTabGetSupplement(expertID: Contact.main()!.pa_id))
        Server.shared.multipassURL(path: Server.shared.FuelQuizURL())
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
    
    private func openFormulation()
    {
        analytics.log(event: .prlMoreTabShowIngredients)
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

extension MoreViewController: TodayWebViewControllerDelegate
{
    func todayWebViewDismissed()
    {
        Contact.main()!.getFuel
        {
            PlansManager.shared.loadPlans()
        }
    }
}
