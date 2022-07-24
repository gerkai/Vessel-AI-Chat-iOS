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
}

protocol SocialAuthViewDelegate
{
    func gotSocialAuthToken(isBrandNewAccount: Bool, loginType: LoginType)
}

class SocialAuthViewController: UIViewController, WKNavigationDelegate, WKUIDelegate
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
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        // TODO: Add analytics for viewed page
    }
    
    @IBAction func doneButtonAction(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }

    func loadContact()
    {
        Server.shared.getContact
        { contact in
            //store the main contactID for use whenever we need to reference the main contact later in the app.
            Contact.MainID = contact.id
            
            //save this contact into the object store
            ObjectStore.shared.serverSave(contact)
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
        { error in
            let errorString = error?.localizedDescription ?? NSLocalizedString("Couldn't get contact", comment: "")
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
        #warning ("CW: Temporary fix until backend gets fixed")
        let fixString = urlString?.replacingOccurrences(of: "/v2/", with: "/v3/")
        //print("\(String(describing: fixString))")
        //print("Retrieve URL: \(String(describing: retrieveURL))")
        if fixString!.contains(retrieveURL)
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
                    self.dismiss(animated: true)
                    {
                        self.loadContact()
                    }
                },
                onFailure:
                {string in
                    UIView.showError(text: NSLocalizedString("Oops, Something went wrong", comment: "Server Error"), detailText: "\(String(describing: string))", image: nil)
                })
            }
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
}
