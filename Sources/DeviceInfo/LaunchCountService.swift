/*
 |  _   ____   ____   _
 | | |‾|  ⚈ |-| ⚈  |‾| |
 | | |  ‾‾‾‾| |‾‾‾‾  | |
 |  ‾        ‾        ‾
 */

import Foundation
import CloudKit

public struct LaunchCountService {
    
    // MARK: - Public properties
    
    /// Number of launches recorded on device for current app version ("1.0.1")
    public var launchCountForCurrentVersion: Int {
        return launchCount(for: deviceInfoService.appVersion)
    }
    
    /// Number of launches recorded on device across all app versions
    public var launchCountForAllVersions: Int {
        let versionCounts = launchCountsForAllVersions()
        guard !versionCounts.isEmpty else { return 0 }
        let allCounts = versionCounts.map { $0.1 }
        let total = allCounts.reduce(0, +)
        return total
    }
    
    
    // MARK: - Internal properties
    
    let sharedAppGroupContainer: String?
    var deviceInfoService: DeviceInfoServiceContract
    var useCloudKit = false
    var isCloudKitAvailable = false
    
    
    // MARK: - Computed properties
    
    var shouldUseCloudKit: Bool {
        return useCloudKit && isCloudKitAvailable
    }
    
    
    // MARK: - Constants
    
    enum Keys {
        fileprivate static var versions: String { return #function }
    }

    
    // MARK: - Initializers
    
    /**
     - parameters:
        - deviceInfoService: Service to provide information about current
        version number
        - sharedAppGroupContainer: Optional identifier to use a shared
        `UserDefaults` suite for storing launch information.
        - useCloudKit: Flag to store values in `NSUbiquitousKeyValueStore`
        instead of `UserDefaults` if available
     */
    public init(sharedAppGroupContainer: String? = nil, useCloudKit: Bool = false, deviceInfoService: DeviceInfoServiceContract = DeviceInfoService()) {
        self.deviceInfoService = deviceInfoService
        self.sharedAppGroupContainer = sharedAppGroupContainer
        self.useCloudKit = useCloudKit
        let token = FileManager.default.ubiquityIdentityToken
        isCloudKitAvailable = token != nil
    }
    
    
    // MARK: - Public functions
    
    /// Increment launch count for current app version ("1.0.1")
    @discardableResult public func incrementLaunchCountForCurrentVersion() -> Bool {
        return incrementLaunchCount(for: deviceInfoService.appVersion)
    }

}


// MARK: - Private functions

private extension LaunchCountService {
    
    func launchCountsForAllVersions() -> [String: Int] {
        if shouldUseCloudKit {
            let store = NSUbiquitousKeyValueStore.default
            return store.object(forKey: Keys.versions) as? [String: Int] ?? [:]
        } else {
            let defaults: UserDefaults
            if let sharedDefaults = UserDefaults(suiteName: sharedAppGroupContainer) {
                defaults = sharedDefaults
            } else {
                defaults = UserDefaults.standard
            }
            return defaults.object(forKey: Keys.versions) as? [String: Int] ?? [:]
        }
    }
    
    func launchCount(for version: String) -> Int {
        return launchCountsForAllVersions()[version] ?? 0
    }
    
    @discardableResult func incrementLaunchCount(for version: String) -> Bool {
        if shouldUseCloudKit {
            let store = NSUbiquitousKeyValueStore.default
            var updatedVersionsCounts = launchCountsForAllVersions()
            let updatedCount = 1 + launchCount(for: version)
            updatedVersionsCounts[version] = updatedCount
            store.set(updatedVersionsCounts, forKey: Keys.versions)
        } else {
            let defaults: UserDefaults
            if let sharedDefaults = UserDefaults(suiteName: sharedAppGroupContainer) {
                defaults = sharedDefaults
            } else {
                defaults = UserDefaults.standard
            }
            var updatedVersionsCounts = launchCountsForAllVersions()
            let updatedCount = 1 + launchCount(for: version)
            updatedVersionsCounts[version] = updatedCount
            defaults.set(updatedVersionsCounts, forKey: Keys.versions)
        }
        return true
    }
    
}
