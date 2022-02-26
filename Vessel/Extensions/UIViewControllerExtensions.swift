//
//  UIViewControllerExtensions.swift
//  Vessel
//
//  Created by Carson Whitsett on 2/25/22.
//

import UIKit
import SafariServices

extension UIViewController
{
    func openInSafari(url: String)
    {
        if let url = URL(string: url)
        {
            let vc = SFSafariViewController(url: url)
            vc.modalPresentationStyle = .overCurrentContext
            present(vc, animated: true)
        }
    }
}
