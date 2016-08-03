/*
 |  _   ____   ____   _
 | ⎛ |‾|  ⚈ |-| ⚈  |‾| ⎞
 | ⎝ |  ‾‾‾‾| |‾‾‾‾  | ⎠
 |  ‾        ‾        ‾
 */

import UIKit

public struct DeviceInfoService {
    
    // MARK: - Public properties
    
    /// e.g. "iPhone OS"
    public var osName: String {
        return UIDevice.currentDevice().systemName
    }
    
    /// e.g. "9.3"
    public var osVersion: String {
        return UIDevice.currentDevice().systemVersion
    }
    
    /// e.g. "142" or "1.0.1.142"
    public var appBuildNumber: String {
        return versionNumberService.buildNumber
    }
    
    /// e.g. "com.example.app"
    public var appIdentifier: String {
        return NSBundle.mainBundle().bundleIdentifier!
    }
    
    /// e.g. "Lister"
    public var appName: String {
        return NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String
    }
    
    /// e.g. "1.0.1"
    public var appVersion: String {
        return versionNumberService.versionNumber
    }
    
    /// User-facing name of device, e.g. "iPhone 6S Plus"
    public var deviceName: String {
        return UIDevice.currentDevice().modelName
    }
    
    /// Identifier of device model, e.g. "iPhone8,2"
    public var deviceType: String {
        return UIDevice.currentDevice().modelIdentifier
    }
    
    /// Identifier of device model, e.g. "iPhone8,2" (Same as `deviceType`)
    public var deviceVersion: String {
        return UIDevice.currentDevice().modelIdentifier
    }
    
    /// Unique identifier of device, same across apps from a single vendor
    public var deviceIdentifier: String {
        return UIDevice.currentDevice().identifierForVendor!.UUIDString
    }
    
    /// The first preferred language of the user, e.g. "en-US"
    public var language: String {
        return NSLocale.preferredLanguages().first!
    }
    
    /// Identifier of the user's current locale, e.g. "en_US"
    public var locale: String {
        return NSLocale.currentLocale().localeIdentifier
    }
    
    /// Pixel density of device screen, e.g. "3.0"
    public var screenDensity: CGFloat {
        return UIScreen.mainScreen().scale
    }
    
    /// Height of screen in points, e.g. "736.0"
    public var screenHeight: CGFloat {
        return UIScreen.mainScreen().bounds.height
    }
    
    /// Width of screen in points, e.g. "414.0"
    public var screenWidth: CGFloat {
        return UIScreen.mainScreen().bounds.width
    }
    
    /// Name of user's current time zone, e.g. "American/Denver"
    public var timezone: String {
        return NSCalendar.currentCalendar().timeZone.name
    }
    

    // MARK: - Internal properties
    
    var versionNumberService = VersionNumberService()
    
    
    // MARK: - Initializers
    
    public init() { }
    
    
    // MARK: - Public functions
    
    /**
     Formatted dictionary with device information used in connection
     with registering for remote notifications and capturing device
     information
     
     - parameter token: Optional string to include in dictionary, usually
        processed from device token data, e.g.
        ```
        let setToTrim = NSCharacterSet( charactersInString: "<>" )
        let tokenString = deviceToken.description.stringByTrimmingCharactersInSet(setToTrim).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())

        ```
     */
    public func deviceInfoDictionary(token: String? = nil) -> [String: AnyObject] {
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
