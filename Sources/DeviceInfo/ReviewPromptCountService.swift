/*
 |  _   ____   ____   _
 | | |‾|  ⚈ |-| ⚈  |‾| |
 | | |  ‾‾‾‾| |‾‾‾‾  | |
 |  ‾        ‾        ‾
 */
//
//  Copyright © 2018 BSN Design. All rights reserved.
//

import Foundation
import CloudKit

public struct ReviewPromptCountService {
    
    // MARK: - Public properties
    
    /// Number of review prompts recorded on device for current app version ("1.0.1")
    public var reviewPromptCountForCurrentVersion: Int {
        return reviewPromptCount(for: deviceInfoService.appVersion)
    }
    
    /// Number of review prompts recorded on device across all app versions
    public var reviewPromptCountForAllVersions: Int {
        let reviewPromptCounts = reviewPromptCountsForAllVersions()
        guard !reviewPromptCounts.isEmpty else { return 0 }
        let allCounts = reviewPromptCounts.map { $0.1 }
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
        fileprivate static var reviewPromptVersions: String { return #function }
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
    
    /// Increment review prompt count for current app version ("1.0.1")
    @discardableResult public func incrementReviewPromptCountForCurrentVersion() -> Bool {
        return incrementReviewPromptCount(deviceInfoService.appVersion)
    }
    
}


// MARK: - Private functions

private extension ReviewPromptCountService {
    
    func reviewPromptCountsForAllVersions() -> [String: Int] {
        if shouldUseCloudKit {
            let store = NSUbiquitousKeyValueStore.default
            return store.object(forKey: Keys.reviewPromptVersions) as? [String: Int] ?? [:]
        } else {
            let defaults: UserDefaults
            if let sharedDefaults = UserDefaults(suiteName: sharedAppGroupContainer) {
                defaults = sharedDefaults
            } else {
                defaults = UserDefaults.standard
            }
            return defaults.object(forKey: Keys.reviewPromptVersions) as? [String: Int] ?? [:]
        }
    }
    
    func reviewPromptCount(for version: String) -> Int {
        return reviewPromptCountsForAllVersions()[version] ?? 0
    }
    
    @discardableResult func incrementReviewPromptCount(_ version: String) -> Bool {
        if shouldUseCloudKit {
            let store = NSUbiquitousKeyValueStore.default
            var updatedReviewPromptCounts = reviewPromptCountsForAllVersions()
            let updatedCount = 1 + reviewPromptCount(for: version)
            updatedReviewPromptCounts[version] = updatedCount
            store.set(updatedReviewPromptCounts, forKey: Keys.reviewPromptVersions)
        } else {
            let defaults: UserDefaults
            if let sharedDefaults = UserDefaults(suiteName: sharedAppGroupContainer) {
                defaults = sharedDefaults
            } else {
                defaults = UserDefaults.standard
            }
            var updatedReviewPromptCounts = reviewPromptCountsForAllVersions()
            let updatedCount = 1 + reviewPromptCount(for: version)
            updatedReviewPromptCounts[version] = updatedCount
            defaults.set(updatedReviewPromptCounts, forKey: Keys.reviewPromptVersions)
        }
        return true
    }
    
}
