//
//  Analytics+Injection.swift
//  Vessel
//
//  Created by Nicolas Medina on 7/12/22.
//

extension Resolver
{
    public static func registerAnalytics()
    {
        register { MixpanelAnalytics() as Analytics }
        //register { ConsolePrintedAnalytics() as Analytics } // Uncomment to print analytics to console
    }
}
