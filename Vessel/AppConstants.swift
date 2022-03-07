//
//  AppConstants.swift
//  Vessel
//
//  Created by Carson Whitsett on 2/25/22.
//

import UIKit

struct Constants
{
    //website links
    static let websiteURL = "https://vesselhealth.com/pages"
    static let privacyPolicyURL = "\(websiteURL)/privacy-policy.html"
    static let termsOfServiceURL = "\(websiteURL)/terms-of-service.html"
    
    //server environment
    static let environmentKey = "Environment"
    static let PROD_INDEX = 0
    static let STAGING_INDEX = 1
    static let DEV_INDEX = 2
    
    static let MinimumPasswordLength: Int = 6
    
    //used for reducing content on smaller screens
    static let SMALL_SCREEN_HEIGHT_THRESHOLD  =  700.0
    
    //common date formats
    static let SERVER_DATE_FORMAT = "yyyy-MM-dd"
    
    static let GENDER_MALE = "m"
    static let GENDER_FEMALE = "f"
    static let GENDER_OTHER = "o"
}
