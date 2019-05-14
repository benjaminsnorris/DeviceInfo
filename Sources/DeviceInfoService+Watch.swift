/*
 |  _   ____   ____   _
 | | |‾|  ⚈ |-| ⚈  |‾| |
 | | |  ‾‾‾‾| |‾‾‾‾  | |
 |  ‾        ‾        ‾
 */

import Foundation
import WatchKit

public extension DeviceInfoServiceContract {
    
    /// e.g. "iPhone OS"
    public var osName: String {
        return WKInterfaceDevice.current().systemName
    }
    
    /// e.g. "9.3"
    public var osVersion: String {
        return WKInterfaceDevice.current().systemVersion
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
    
    /// e.g. "Lister 1.0.1.142"
    public var appNameWithVersion: String {
        guard let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String else { return "Unnamed App" }
        return "\(appName) \(appBuildNumber)"
    }
    
    /// User-facing display name of device, e.g. "John's Apple Watch"
    var deviceDisplayName: String {
        return WKInterfaceDevice.current().name
    }
    
    /// User-facing name of device, e.g. "iPhone 6S Plus"
    public var deviceModelName: String {
        return WKInterfaceDevice.current().model
    }
    
    /// Identifier of device model, e.g. "iPhone8,2"
    public var deviceType: String {
        return "Apple Watch"
    }
    
    /// Identifier of device model, e.g. "iPhone8,2" (Same as `deviceType`)
    public var deviceVersion: String {
        return WKInterfaceDevice.current().model
    }
    
    /// Unique identifier of device, same across apps from a single vendor
    public var deviceIdentifier: String {
        // TODO: Get a real identifier for the watch
        return UUID().uuidString
    }
    
    /// The first preferred language of the user, e.g. "en-US"
    public var language: String {
        return Locale.preferredLanguages.first!
    }
    
    /// Identifier of the user's current locale, e.g. "en_US"
    public var locale: String {
        return Locale.current.identifier
    }
    
    /// Identifier of the user's current translation, e.g. "en"
    var translation: String {
        return Bundle.main.preferredLocalizations.first ?? ""
    }
    
    /// Pixel density of device screen, e.g. "3.0"
    public var screenDensity: CGFloat {
        return WKInterfaceDevice.current().screenScale
    }
    
    /// Height of screen in points, e.g. "736.0"
    public var screenHeight: CGFloat {
        return WKInterfaceDevice.current().screenBounds.height
    }
    
    /// Width of screen in points, e.g. "414.0"
    public var screenWidth: CGFloat {
        return WKInterfaceDevice.current().screenBounds.width
    }
    
    /// Name of user's current time zone, e.g. "American/Denver"
    public var timezone: String {
        return Calendar.current.timeZone.identifier
    }
    
    /**
     Formatted token from device token received when registering for
     remote notifications.
     
     - parameter deviceToken: Data object received when registering for
     remote notifications
     
     - returns: Formatted token string
     */
    public func formattedToken(from deviceToken: Data) -> String {
        return deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
    }
    
    /**
     Formatted dictionary with device information used in connection
     with registering for remote notifications and capturing device
     information
     
     - Parameters:
     - token: Optional string to include in dictionary, usually processed from device token data
     - latitude: Optional if obtained from user
     - longitude: Optional if obtained from user
     - nullForMissingValues: Flag for missing values to omit or set as `NSNull()`
     */
    public func deviceInfoDictionary(with token: String?, latitude: Double? = nil, longitude: Double? = nil, nullForMissingValues: Bool = false) -> [String: Any] {
        var object: [String: Any] = [
            "name": deviceDisplayName,
            ]
        var locationObject: [String: Any] = [
            "timezone": timezone,
            ]
        if let latitude = latitude {
            locationObject["lat"] = latitude
        } else if nullForMissingValues {
            locationObject["lat"] = NSNull()
        }
        if let longitude = longitude {
            locationObject["lng"] = longitude
        } else if nullForMissingValues {
            locationObject["lng"] = NSNull()
        }
        object["location"] = locationObject
        
        object["locale"] = [
            "translation": translation,
            "language": language,
            "identifier": locale,
        ]
        object["hardware"] = [
            "name": deviceModelName,
            "version": deviceVersion,
            "type": deviceType,
            "identifier": deviceIdentifier,
        ]
        object["OS"] = [
            "name": osName,
            "version": osVersion,
        ]
        
        var appObject: [String: Any] = [
            "name": appName,
            "version": appVersion,
            "build": appBuildNumber,
            "identifier": appIdentifier,
            ]
        if let token = token {
            appObject["token"] = token
        } else if nullForMissingValues {
            appObject["token"] = NSNull()
        }
        object["app"] = appObject
        
        object["screen_metrics"] = [
            "density": screenDensity,
            "h": screenHeight,
            "w": screenWidth,
        ]
        
        return object
    }
    
    // To be honest, I don't know why this is required here. The availability
    // tag should prevent this from being required. So the implementation is
    // intentionally simplistic.
    
    @available(iOSApplicationExtension 10.0, *)
    public func deviceAndSettingsInfo(with token: String?, latitude: Double? = nil, longitude: Double? = nil, nullForMissingValues: Bool = false, completionHandler: @escaping (_ infoDictionary: [String: Any]) -> ()) {
        let info = deviceInfoDictionary(with: token, latitude: latitude, longitude: longitude, nullForMissingValues: nullForMissingValues)
        completionHandler(info)
    }

}


public struct DeviceInfoService: DeviceInfoServiceContract {
    
    public init() { }
    
}
