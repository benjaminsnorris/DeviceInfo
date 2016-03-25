//
//  DeviceInfoService.swift
//  DeviceInfo
//
//  Created by Ben Norris on 3/25/16.
//  Copyright © 2016 BSN Design. All rights reserved.
//

import UIKit
import VersionNumber

public struct DeviceInfoService {
    
    // MARK: - Public properties
    
    public var osName: String {
        return UIDevice.currentDevice().systemName
    }
    
    public var osVersion: String {
        return UIDevice.currentDevice().systemVersion
    }
    
    public var appBuildNumber: String {
        return versionNumberService.currentVersionShort
    }
    
    public var appIdentifier: String {
        return NSBundle.mainBundle().bundleIdentifier!
    }
    
    public var appName: String {
        return NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String
    }
    
    public var appVersion: String {
        return versionNumberService.currentVersion
    }
    
    public var deviceName: String {
        return UIDevice.currentDevice().modelName
    }
    
    public var deviceType: String {
        return UIDevice.currentDevice().modelIdentifier
    }
    
    public var deviceVersion: String {
        return UIDevice.currentDevice().modelIdentifier
    }
    
    public var deviceIdentifier: String {
        return UIDevice.currentDevice().identifierForVendor!.UUIDString
    }
    
    public var language: String {
        return NSLocale.preferredLanguages().first!
    }
    
    public var locale: String {
        return NSLocale.currentLocale().localeIdentifier
    }
    
    public var screenDensity: CGFloat {
        return UIScreen.mainScreen().scale
    }
    
    public var screenHeight: CGFloat {
        return UIScreen.mainScreen().bounds.height
    }
    
    public var screenWidth: CGFloat {
        return UIScreen.mainScreen().bounds.width
    }
    
    public var timezone: String {
        return NSCalendar.currentCalendar().timeZone.name
    }
    

    // MARK: - Internal properties
    
    var versionNumberService = VersionNumberService()
    
    
    // MARK: - Initializers
    
    public init() { }
    
    
    // MARK: - Public properties
    
    func deviceInfoDictionary(token: String? = nil) -> [String: AnyObject] {
        return [ "device": [
            "data": [
                "OS": [
                    "name": osName,
                    "version": osVersion
                ],
                "app": [
                    "build": appBuildNumber,
                    "identifier": appIdentifier,
                    "name": appName,
                    "version": appVersion
                ],
                "hardware": [
                    "name": deviceName,
                    "type": deviceType,
                    "version": deviceVersion,
                    "identifier": deviceIdentifier
                ],
                "language": language,
                "locale": locale,
                "screen_metrics": [
                    "density": screenDensity,
                    "h": screenHeight,
                    "w": screenWidth
                ],
                "timezone": timezone,
                "token": token ?? ""
                ]
            ]
        ]
    }
    
}
