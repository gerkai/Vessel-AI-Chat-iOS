//
//  AppDelegate+Injection.swift
//  Vessel
//
//  Created by Nicolas Medina on 7/12/22.
//

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        registerAnalytics()
    }
}
