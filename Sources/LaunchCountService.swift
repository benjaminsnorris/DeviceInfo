/*
 |  _   ____   ____   _
 | ⎛ |‾|  ⚈ |-| ⚈  |‾| ⎞
 | ⎝ |  ‾‾‾‾| |‾‾‾‾  | ⎠
 |  ‾        ‾        ‾
 */

import Foundation

public struct LaunchCountService {
    
    // MARK: - Public properties
    
    /// Number of launches recorded on device for current app version ("1.0.1")
    public var launchCountForCurrentVersion: Int {
        return launchCount(deviceInfoService.appVersion)
    }
    
    /// Number of launches recorded on device across all app versions
    public var launchCountForAllVersions: Int {
        guard let versionCounts = launchCountsForAllVersions() else { return 0 }
        guard versionCounts.count > 0 else { return 0 }
        let allCounts = versionCounts.flatMap { $0.1 }
        let total = allCounts.reduce(0, combine: +)
        return total
    }
    
    
    // MARK: - Internal properties
    
    let sharedAppGroupContainer: String?
    var deviceInfoService: DeviceInfoServiceContract = DeviceInfoService()
    
    
    // MARK: - Constants
    
    private let versionsKey = "versions"
    
    
    // MARK: - Initializers
    
    /**
     - parameter sharedAppGroupContainer: Optional identifier to use a shared
        `NSUserDefaults` suite for storing launch information.
     */
    public init(sharedAppGroupContainer: String? = nil) {
        self.sharedAppGroupContainer = sharedAppGroupContainer
    }
    
    
    // MARK: - Public functions
    
    /// Increment launch count for current app version ("1.0.1")
    public func incrementLaunchCountForCurrentVersion() -> Bool {
        return incrementLaunchCount(deviceInfoService.appVersion)
    }

}


// MARK: - Private functions

private extension LaunchCountService {
    
    func launchCountsForAllVersions() -> [String: Int]? {
        let defaults: NSUserDefaults
        if let sharedDefaults = NSUserDefaults(suiteName: sharedAppGroupContainer) {
            defaults = sharedDefaults
        } else {
            defaults = NSUserDefaults.standardUserDefaults()
        }
        guard let versionsCounts = defaults.objectForKey(versionsKey) as? [String: Int] else { return nil }
        return versionsCounts
    }
    
    func launchCount(version: String) -> Int {
        guard let versionsCounts = launchCountsForAllVersions() else { return 0 }
        if let count = versionsCounts[version] {
            return count
        }
        return 0
    }
    
    func incrementLaunchCount(version: String) -> Bool {
        let defaults: NSUserDefaults
        if let sharedDefaults = NSUserDefaults(suiteName: sharedAppGroupContainer) {
            defaults = sharedDefaults
        } else {
            defaults = NSUserDefaults.standardUserDefaults()
        }
        var updatedCount = 1
        var updatedVersionsCounts = [String: Int]()
        if let versionsCounts = launchCountsForAllVersions() {
            updatedVersionsCounts = versionsCounts
            if let count = versionsCounts[version] {
                updatedCount += count
            }
        }
        updatedVersionsCounts[version] = updatedCount
        defaults.setObject(updatedVersionsCounts, forKey: versionsKey)
        return true
    }
    
}
