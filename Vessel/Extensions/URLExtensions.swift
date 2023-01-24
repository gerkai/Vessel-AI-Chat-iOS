//
//  URLExtensions.swift
//  Vessel
//
//  Created by Carson Whitsett on 1/21/23.
//

import Foundation

extension URL
{
    func valueOf(_ queryParameterName: String) -> String?
    {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParameterName })?.value
    }
}
