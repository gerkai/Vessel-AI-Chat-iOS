//
//  SocialAuthViewController.swift
//  vessel-ios
//
//  Created by Carson Whitsett on 3/24/22.
//  Copyright © 2022 Vessel Health Inc. All rights reserved.
//  Based on Login Flow: https://www.notion.so/vesselhealth/Login-2dbc7f76cf4c4953abd8b4aa7bc34bc5

import UIKit
import WebKit

enum LoginType: String
{
    case google = "Google"
    case apple = "Apple"
    case email = "Email"
}

protocol SocialAuthViewDelegate
{
    func gotSocialAuthToken(isBrandNewAccount: Bool, loginType: LoginType)
}

class SocialAuthViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, VesselScreenIdentifiable
{
    @IBOutlet weak var webContentView: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var webView: WKWebView!
    
    let googleRetrieveLink = Server.shared.googleRetrieveURL()
    let appleRetrieveLink  = Server.shared.appleRetrieveURL()
    var retrieveURL: String!
    var strURL: String!
    var loginType: LoginType = .google
    var delegate: SocialAuthViewDelegate?
    
    @Resolved internal var analytics: Analytics
    let flowName: AnalyticsFlowName = .loginFlow
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if loginType == .google
        {
            retrieveURL = googleRetrieveLink
        }
        else
        {
            retrieveURL = appleRetrieveLink
        }
        webView.uiDelegate = self
        webView.navigationDelegate = self
        //webView.allowsBackForwardNavigationGestures = true
        //the below line resolves 403 error: disallowed_useragent when signing in with google
        webView.customUserAgent = "Chrome/56.0.0.0 Mobile"
        
        activity.startAnimating()
        activity.hidesWhenStopped = true
        let url = URL(string: strURL)
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
    @IBAction func doneButtonAction(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }

    func loadContact()
    {
        ObjectStore.shared.loadMainContact
        {
            let contact = Contact.main()!
            contact.loginType = self.loginType
            
            //handle practitioner attribution
            if let id = Contact.PractitionerID
            {
                Log_Add("loadContact: Setting attribution: \(id)")
                contact.pa_id = id
                Contact.PractitionerID = nil
            }
            
            ObjectStore.shared.clientSave(contact)

            if contact.isBrandNew()
            {
                self.delegate?.gotSocialAuthToken(isBrandNewAccount: true, loginType: self.loginType)
            }
            else
            {
                self.delegate?.gotSocialAuthToken(isBrandNewAccount: false, loginType: self.loginType)
            }
        }
        onFailure:
        {
            let errorString = NSLocalizedString("Couldn't get contact", comment: "")
            UIView.showError(text: NSLocalizedString("Oops, Something went wrong", comment: "Server Error Message"), detailText: errorString, image: nil)
        }
    }
    
//MARK: webView delegates
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        activity.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error)
    {
        activity.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
    {
        let urlString = navigationAction.request.url?.absoluteString
        
        if urlString!.contains(retrieveURL)
        {
            let host = navigationAction.request.url?.host ?? Server.shared.API().replacingOccurrences(of: "https://", with: "")
            webView.getCookies(for: host)
            { cookies in
                for cookie in cookies
                {
                    HTTPCookieStorage.shared.setCookie(cookie)
                }
                
                Server.shared.getTokens(isGoogle: self.loginType == .google, onSuccess:
                {
                    //print("Social Auth: Sending SHOW SPLASH notification")
                    NotificationCenter.default.post(name: .showSplashScreen, object: nil, userInfo: ["show": true])
                    self.dismiss(animated: true)
                    {
                        self.loadContact()
                    }
                },
                onFailure:
                {string in
                    UIView.showError(text: NSLocalizedString("Oops, Something went wrong", comment: "Server Error"), detailText: "\(String(describing: string))", image: nil)
                    self.dismiss(animated: true)
                })
            }
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
}
