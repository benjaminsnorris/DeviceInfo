/*
 |  _   ____   ____   _
 | ⎛ |‾|  ⚈ |-| ⚈  |‾| ⎞
 | ⎝ |  ‾‾‾‾| |‾‾‾‾  | ⎠
 |  ‾        ‾        ‾
 */

import UIKit

import UIKit

public protocol DeviceInfoServiceContract {
    /// e.g. "iPhone OS"
    var osName: String { get }
    /// e.g. "9.3"
    var osVersion: String { get }
    /// e.g. "142" or "1.0.1.142"
    var appBuildNumber: String { get }
    /// e.g. "com.example.app"
    var appIdentifier: String { get }
    /// e.g. "Lister"
    var appName: String { get }
    /// e.g. "1.0.1"
    var appVersion: String { get }
    /// e.g. "Lister version 1.0.1 (142)"
    var appNameWithVersion: String { get }
    /// User-facing name of device, e.g. "iPhone 6S Plus"
    var deviceName: String { get }
    /// Identifier of device model, e.g. "iPhone8,2"
    var deviceType: String { get }
    /// Identifier of device model, e.g. "iPhone8,2" (Same as `deviceType`)
    var deviceVersion: String { get }
    /// Unique identifier of device, same across apps from a single vendor
    var deviceIdentifier: String { get }
    /// The first preferred language of the user, e.g. "en-US"
    var language: String { get }
    /// Identifier of the user's current locale, e.g. "en_US"
    var locale: String { get }
    /// Pixel density of device screen, e.g. "3.0"
    var screenDensity: CGFloat { get }
    /// Height of screen in points, e.g. "736.0"
    var screenHeight: CGFloat { get }
    /// Width of screen in points, e.g. "414.0"
    var screenWidth: CGFloat { get }
    /// Name of user's current time zone, e.g. "American/Denver"
    var timezone: String { get }
    
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
    func deviceInfoDictionary(_ token: String?) -> [String:Any]
}


public extension DeviceInfoServiceContract {
    
    /// e.g. "iPhone OS"
    public var osName: String {
        return UIDevice.current.systemName
    }
    
    /// e.g. "9.3"
    public var osVersion: String {
        return UIDevice.current.systemVersion
    }
    
    /// e.g. "142" or "1.0.1.142"
    public var appBuildNumber: String {
        guard let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else { return "Unknown" }
        return version
    }

    /// e.g. "com.example.app"
    public var appIdentifier: String {
        return Bundle.main.bundleIdentifier!
    }
    
    /// e.g. "Lister"
    public var appName: String {
        return Bundle.main.infoDictionary!["CFBundleName"] as! String
    }
    
    /// e.g. "1.0.1"
    public var appVersion: String {
        guard let shortVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return "Unknown" }
        return shortVersion
    }
    
    /// e.g. "Lister version 1.0.1 (142)"
    public var appNameWithVersion: String {
        guard let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String else { return "Unnamed App" }
        return "\(appName) version \(appVersion) (\(appBuildNumber))"
    }
    
    /// User-facing name of device, e.g. "iPhone 6S Plus"
    public var deviceName: String {
        return UIDevice.current.modelName
    }
    
    /// Identifier of device model, e.g. "iPhone8,2"
    public var deviceType: String {
        return UIDevice.current.modelIdentifier
    }
    
    /// Identifier of device model, e.g. "iPhone8,2" (Same as `deviceType`)
    public var deviceVersion: String {
        return UIDevice.current.modelIdentifier
    }
    
    /// Unique identifier of device, same across apps from a single vendor
    public var deviceIdentifier: String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    /// The first preferred language of the user, e.g. "en-US"
    public var language: String {
        return Locale.preferredLanguages.first!
    }
    
    /// Identifier of the user's current locale, e.g. "en_US"
    public var locale: String {
        return Locale.current.identifier
    }
    
    /// Pixel density of device screen, e.g. "3.0"
    public var screenDensity: CGFloat {
        return UIScreen.main.scale
    }
    
    /// Height of screen in points, e.g. "736.0"
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    /// Width of screen in points, e.g. "414.0"
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    /// Name of user's current time zone, e.g. "American/Denver"
    public var timezone: String {
        return Calendar.current.timeZone.identifier
    }
    
    public func deviceInfoDictionary(_ token: String?) -> [String:Any] {
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


public struct DeviceInfoService: DeviceInfoServiceContract {
    
    public init() { }

}
