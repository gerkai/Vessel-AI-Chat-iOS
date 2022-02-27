//
//  SocialAuthViewController.swift
//  vessel-ios
//
//  Created by swift on 11/24/21.
//  Copyright © 2021 Vessel Health Inc. All rights reserved.
//

import UIKit
import WebKit

protocol SocialAuthViewDelegate
{
    func gotSocialAuthToken()
}

class SocialAuthViewController: UIViewController, WKNavigationDelegate, WKUIDelegate
{
    @IBOutlet weak var webContentView: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    let googleRetrieveLink = Server.shared.googleRetrieveURL()
    let appleRetrieveLink  = Server.shared.appleRetrieveURL()
    var retrieveURL: String!
    var strURL: String!
    var bIsGoogle: Bool = true
    var delegate: SocialAuthViewDelegate?
    
    
    lazy var webView: WKWebView =
    {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.applicationNameForUserAgent = "Version/8.0.2 Safari/600.2.5"
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.allowsBackForwardNavigationGestures = true
        webView.isUserInteractionEnabled = true
        return webView
    }()
    
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
        
        activity.startAnimating()
        activity.hidesWhenStopped = true
        setupUI()
        let url = URL(string: strURL)
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
    func setupUI()
    {
        self.webContentView.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor
                .constraint(equalTo: self.webContentView.topAnchor),
            webView.leftAnchor
                .constraint(equalTo: self.webContentView.leftAnchor),
            webView.bottomAnchor
                .constraint(equalTo: self.webContentView.bottomAnchor),
            webView.rightAnchor
                .constraint(equalTo: self.webContentView.rightAnchor)
        ])
    }
    
    @IBAction func doneButtonAction(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
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
        //print("\(urlString)")
        //print("Retrieve URL: \(retrieveURL)")
        if urlString!.contains(retrieveURL)
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
                        self.delegate?.gotSocialAuthToken()
                    }
                },
                onFailure:
                {
                    print("FAILED")
                })
            }
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
}
