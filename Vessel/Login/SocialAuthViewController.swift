//
//  SocialAuthViewController.swift
//  vessel-ios
//
//  Created by Carson Whitsett on 3/24/22.
//  Copyright © 2022 Vessel Health Inc. All rights reserved.
//

import UIKit
import WebKit

protocol SocialAuthViewDelegate
{
    func gotSocialAuthToken(isBrandNewAccount: Bool)
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
    var bIsGoogle: Bool = true
    var delegate: SocialAuthViewDelegate?
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if bIsGoogle
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
        Server.shared.getContact
        { contact in
            //store the main contactID for use whenever we need to reference the main contact later in the app.
            Contact.MainID = contact.id
            
            //save this contact into the object store
            ObjectStore.shared.serverSave(contact)
            if contact.isBrandNew()
            {
                self.delegate?.gotSocialAuthToken(isBrandNewAccount: true)
            }
            else
            {
                self.delegate?.gotSocialAuthToken(isBrandNewAccount: false)
            }
        }
        onFailure:
        { error in
            UIView.showError(text: NSLocalizedString("Oops, Something went wrong", comment:"Server Error Message"), detailText: "\(error.localizedCapitalized)", image: nil)
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
        print("\(fixString)")
        print("Retrieve URL: \(retrieveURL)")
        if fixString!.contains(retrieveURL)
        {
            let host = navigationAction.request.url?.host ?? Server.shared.API().replacingOccurrences(of: "https://", with: "")
            webView.getCookies(for: host)
            { cookies in
                for cookie in cookies
                {
                    HTTPCookieStorage.shared.setCookie(cookie)
                }
                
                Server.shared.getTokens(isGoogle: self.bIsGoogle, onSuccess:
                {
                    self.dismiss(animated: true)
                    {
                        self.loadContact()
                    }
                },
                onFailure:
                {string in
                    UIView.showError(text: NSLocalizedString("Oops, Something went wrong", comment: "Server Error"), detailText: "\(string)", image: nil)
                })
            }
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
}
