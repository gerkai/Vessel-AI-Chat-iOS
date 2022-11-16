//
//  VesselScreenIdentifiable.swift
//  Vessel
//
//  Created by Nicolas Medina on 9/21/22.
//
// How to use:
// Just implement the VesselScreenIdentifiable in every viewController you need to track the viewedPage analytics event
// Add a case inside the AnalyticsScreenName enum with the new screen name
// Add two properties to the new viewController: @Resolved internal var analytics: Analaytics and let screenName: AnalyticsScreenName (initialized to the new value added to the enum)
// That's it :)
//

import UIKit

protocol VesselScreenIdentifiable
{
    var flowName: AnalyticsFlowName { get }
    var analytics: Analytics { get }
    var associatedValue: String? { get }
    
    func viewDidAppear(_ animated: Bool)
}

extension VesselScreenIdentifiable where Self: UIViewController
{
    var associatedValue: String?
    {
        nil
    }
}

extension UIViewController
{
    @objc dynamic func _tracked_viewDidAppear(_ animated: Bool)
    {
        _tracked_viewDidAppear(animated)
        // Will only get called when UIViewController implements the VesselScreenIdentifiable protocol
        if let protocolConformingSelf = self as? VesselScreenIdentifiable
        {
            protocolConformingSelf.analytics.log(event: .viewedPage(screenName: String(describing: type(of: self)), flowName: protocolConformingSelf.flowName, associatedValue: protocolConformingSelf.associatedValue))
        }
    }
    
    static func swizzle()
    {
        //So that It applies to all UIViewController childs
        if self != UIViewController.self
        {
            return
        }
        
        let _: () =
        {
            let originalSelector =
            #selector(UIViewController.viewDidAppear(_:))
            let swizzledSelector =
            #selector(UIViewController._tracked_viewDidAppear(_:))
            let originalMethod =
            class_getInstanceMethod(self, originalSelector)
            let swizzledMethod =
            class_getInstanceMethod(self, swizzledSelector)
            method_exchangeImplementations(originalMethod!, swizzledMethod!);
        }()
    }
}
