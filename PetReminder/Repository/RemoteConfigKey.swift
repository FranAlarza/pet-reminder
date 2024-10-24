//
//  RemoteConfigKey.swift
//  PetReminder
//
//  Created by Fran Alarza on 24/10/24.
//

import Foundation
import FirebaseRemoteConfig
import Shake
import FirebaseCore
import FirebaseAnalytics

enum RemoteConfigKey: String {
    case KREVCAT, KSHAKE
}

protocol RemoteConfigServiceProtocol {

    func getString(forKey key: RemoteConfigKey) -> String
    func getBool(forKey key: RemoteConfigKey) -> Bool
    func getNumber(forKey key: RemoteConfigKey) -> NSNumber
    func getJsonValue(forKey key: RemoteConfigKey) -> [String: Any]?
    func getData(forKey key: RemoteConfigKey) -> Data
}

class RemoteConfigService: RemoteConfigServiceProtocol {
    private let remoteConfig: RemoteConfig
    
    #if DEBUG
    let expirationDuration =  5
    #else
    let expirationDuration =  3600 // 1 hour in seconds
    #endif
    
    init() {
        FirebaseApp.configure()
        Analytics.setAnalyticsCollectionEnabled(true)
        remoteConfig = RemoteConfig.remoteConfig()
        initialFetch()
    }
    
    @discardableResult
    func fetchConfig() async throws -> Bool {
        try await remoteConfig.fetch(withExpirationDuration: TimeInterval(expirationDuration))
        return try await remoteConfig.activate()
    }

    func getString(forKey key: RemoteConfigKey) -> String {
        return remoteConfig[key.rawValue].stringValue
    }

    func getBool(forKey key: RemoteConfigKey) -> Bool {
        return remoteConfig[key.rawValue].boolValue
    }
    
    func getNumber(forKey key: RemoteConfigKey) -> NSNumber {
        return remoteConfig[key.rawValue].numberValue
    }
    
    func getJsonValue(forKey key: RemoteConfigKey) -> [String: Any]? {
        return remoteConfig[key.rawValue].jsonValue as? [String: Any]
    }
    
    func getData(forKey key: RemoteConfigKey) -> Data {
        return remoteConfig[key.rawValue].dataValue
    }
}
  
private extension RemoteConfigService {
    
    func initialFetch() {
        Task {
            do {
                let _ = try await fetchConfig()
                print("[RemoteConfig] - ✅ Fetch succeed")
                initShake()
            } catch {
                print("[RemoteConfig] - ❌ Fetch failed with \(error) retrying...")
                initialFetch()
            }
        }
    }
    
    func initShake() {
        configureShake()
    }
    
    func configureShake() {
        
        Shake.start(apiKey: getString(forKey: .KSHAKE))

        Shake.configuration.isAutoVideoRecordingEnabled = true
        Shake.configuration.isCrashReportingEnabled = true
        Shake.configuration.isConsoleLogsEnabled = true
            
    }
}
