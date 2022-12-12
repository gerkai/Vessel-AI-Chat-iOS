//
//  WKWebviewExtension.swift
//  Vessel
//
//  Created by Carson Whitsett on 3/25/2022.
//  Copyright © 2022 Vessel Health Inc. All rights reserved.
//

import Foundation
import WebKit

extension WKWebView
{
    private var httpCookieStore: WKHTTPCookieStore  { return WKWebsiteDataStore.default().httpCookieStore }

    func getCookiesDict(for domain: String? = nil, completion: @escaping ([String: Any]) -> ())
    {
        var cookieDict = [String: AnyObject]()
        httpCookieStore.getAllCookies
        { cookies in
            for cookie in cookies
            {
                if let domain = domain
                {
                    if cookie.domain.contains(domain)
                    {
                        cookieDict[cookie.name] = cookie.properties as AnyObject?
                    }
                }
                else
                {
                    cookieDict[cookie.name] = cookie.properties as AnyObject?
                }
            }
            completion(cookieDict)
        }
    }
    
    func getCookies(for domain: String? = nil, completion: @escaping ([HTTPCookie]) -> ())
    {
        var data = [HTTPCookie]()
        httpCookieStore.getAllCookies
        { cookies in
            for cookie in cookies
            {
                if let domain = domain
                {
                    if cookie.domain.contains(domain)
                    {
                        data.append(cookie)
                    }
                }
            }
            completion(data)
        }
    }
}
