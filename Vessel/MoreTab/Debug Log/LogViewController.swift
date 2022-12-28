//
//  LogViewController.swift
//
//  Created by Carson Whitsett on 8/13/21.
//

import UIKit
import MessageUI

let MAIL_RECIPIENT = "carson@vesselhealth.com"

class LogViewController: UIViewController, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var logView: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        logView.text = Log_Get()
        NotificationCenter.default.addObserver(self, selector: #selector(GotLogUpdate(notification:)), name: Notification.Name.LOG_UPDATED_NOTIFICATION, object: nil)
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("❇️ \(self)")
        }
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("❌ \(self)")
        }
    }
    
    @objc func GotLogUpdate(notification: NSNotification)
    {
        logView.text = Log_Get()
    }
    
    @IBAction func sendLog()
    {
        if MFMailComposeViewController.canSendMail()
        {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.setSubject("Debug Log")
            mailComposer.setToRecipients([MAIL_RECIPIENT])
            mailComposer.setMessageBody(Log_Get(), isHTML: false)
            mailComposer.modalPresentationStyle = .fullScreen
            present(mailComposer, animated: true)
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
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        controller.dismiss(animated: true)
    }
    
    @IBAction func clearLog()
    {
        Log_Clear()
    }
    
    @IBAction func back()
    {
        navigationController?.popViewController(animated: true)
    }
}
