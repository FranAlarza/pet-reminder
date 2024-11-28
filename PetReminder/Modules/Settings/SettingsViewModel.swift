//
//  SettingsViewModel.swift
//  PetReminder
//
//  Created by Fran Alarza on 22/10/24.
//

import Foundation
import Combine
import RevenueCat
import SwiftUICore

final class SettingsViewModel: ObservableObject {
 
    enum SubscriptionState: String {
        
        case subscribed = "Subscribed"
        case notSubscribed = "Not Subscribed"
        
        var title: String {
            switch self {
            case .subscribed: return "Upgrade Now!"
            case .notSubscribed: return "Unlock all pro features"
            }
        }
        
        var color: Color {
            switch self {
            case .subscribed: return .green
            case .notSubscribed: return .red
            }
        }
    }
    
    @Published var subscriptionState = SubscriptionState.notSubscribed
    
    private let subscriptionManager: SubscriptionManager
    private let cancellables = Set<AnyCancellable>()
    
    init(subscriptionManager: SubscriptionManager = SubscriptionManager.shared) {
        self.subscriptionManager = subscriptionManager
        start()
    }
    
    func start() {
        subscriptionManager.subscribePublisher
            .map { isSuscribed in
                isSuscribed
                ? SubscriptionState.subscribed
                : SubscriptionState.notSubscribed
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
