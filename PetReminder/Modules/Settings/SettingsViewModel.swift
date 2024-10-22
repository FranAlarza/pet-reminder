//
//  SettingsViewModel.swift
//  PetReminder
//
//  Created by Fran Alarza on 22/10/24.
//

import Foundation
import Combine
import RevenueCat

final class SettingsViewModel: ObservableObject {
 
    private enum SubscriptionState: String {
        
        case subscribed = "Subscribed"
        case notSubscribed = "Not Subscribed"
    }
    
    @Published private(set) var subscriptionState = SubscriptionState.notSubscribed.rawValue
    
    private let subscriptionManager: SubscriptionManager
    private let cancellables = Set<AnyCancellable>()
    
    init(subscriptionManager: SubscriptionManager = SubscriptionManager()) {
        self.subscriptionManager = subscriptionManager
    }
    
    func start() {
        subscriptionManager.subscribePublisher
            .map { isSuscribed -> String in
                isSuscribed
                ? SubscriptionState.subscribed.rawValue
                : SubscriptionState.notSubscribed.rawValue
            }.assign(to: &$subscriptionState)
    }
    
    func restorePurchase() {
        Task {
            do {
                _ = try await Purchases.shared.restorePurchases()
            } catch {
                print("Error restoring purchase: \(error)")
            }
        }
    }
}
