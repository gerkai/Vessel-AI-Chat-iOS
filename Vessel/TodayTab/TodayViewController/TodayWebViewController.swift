//
//  TodayWebViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 1/5/23.
//

import UIKit
import WebKit

protocol TodayWebViewControllerDelegate: AnyObject
{
    func todayWebViewDismissed()
}

class TodayWebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate
{
    @IBOutlet weak var webView: WKWebView!
    var url: String!
    var delegate: TodayWebViewControllerDelegate?
    
    static func initWith(url: String, delegate: TodayWebViewControllerDelegate? = nil) -> TodayWebViewController
    {
        let storyboard = UIStoryboard(name: "TodayTab", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TodayWebViewController") as! TodayWebViewController
        vc.url = url
        vc.delegate = delegate
        return vc
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let url = URL(string: self.url)
        let request = URLRequest(url: url!)
        webView.navigationDelegate = self
        webView.configuration.websiteDataStore = WKWebsiteDataStore.default()
        webView.configuration.preferences.setValue(true, forKey: "developerExtrasEnabled")
        webView.load(request)
    }
    
    @IBAction func done()
    {
        delegate?.todayWebViewDismissed()
        dismiss(animated: true)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
    {
        if let urlStr = navigationAction.request.url?.absoluteString
        {
          print(urlStr)
        }

        decisionHandler(.allow)
      }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error)
    {
        print("ERROR: \(error)")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error)
    {
        print("ERROR: \(error)")
    }
    
    /*cw uncomment to view javascript
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        webView.evaluateJavaScript("JSON.stringify(localStorage)")
        { (result, error) in
            if let result = result
            {
                Log_Add("Javascript: \(result)")
            }
            else if let error = error
            {
                print("Error while getting local storage: \(error.localizedDescription)")
            }
        }
    }
     */
    // this handles target=_blank links by opening them in the same view
    /*func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView?
    {
        if navigationAction.targetFrame == nil
        {
            webView.load(navigationAction.request)
        }
        return nil
    }*/
}
