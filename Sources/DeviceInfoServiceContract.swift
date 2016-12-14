/*
 |  _   ____   ____   _
 | | |‾|  ⚈ |-| ⚈  |‾| |
 | | |  ‾‾‾‾| |‾‾‾‾  | |
 |  ‾        ‾        ‾
 */

import Foundation

public protocol DeviceInfoServiceContract {
    var osName: String { get }
    var osVersion: String { get }
    var appBuildNumber: String { get }
    var appIdentifier: String { get }
    var appName: String { get }
    var appVersion: String { get }
    var appNameWithVersion: String { get }
    var deviceDisplayName: String { get }
    var deviceModelName: String { get }
    var deviceType: String { get }
    var deviceVersion: String { get }
    var deviceIdentifier: String { get }
    var language: String { get }
    var locale: String { get }
    var translation: String { get }
    var screenDensity: CGFloat { get }
    var screenHeight: CGFloat { get }
    var screenWidth: CGFloat { get }
    var timezone: String { get }

    func formattedToken(from deviceToken: Data) -> String
    func deviceInfoDictionary(with token: String?, latitude: Double?, longitude: Double?, nullForMissingValues: Bool) -> [String: Any]

    @available(iOSApplicationExtension 10.0, *)
    func deviceAndSettingsInfo(with token: String?, latitude: Double?, longitude: Double?, nullForMissingValues: Bool, completionHandler: @escaping (_ infoDictionary: [String: Any]) -> ())
}
