//
//  LogViewController.swift
//
//  Created by Carson Whitsett on 8/13/21.
//

import UIKit
import MessageUI

let MAIL_RECIPIENT = "carson@dittylabs.com"

class LogViewController: UIViewController, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var logView: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        logView.text = Log_Get()
        NotificationCenter.default.addObserver(self, selector: #selector(GotLogUpdate(notification:)), name: Notification.Name.LOG_UPDATED_NOTIFICATION, object: nil)
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
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
            mailComposer.delegate = self
            mailComposer.setSubject("Debug Log")
            mailComposer.setToRecipients([MAIL_RECIPIENT])
            mailComposer.setMessageBody(Log_Get(), isHTML: false)
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
    
    @IBAction func clearLog()
    {
        Log_Clear()
    }
}
