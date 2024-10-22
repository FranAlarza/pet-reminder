//
//  SubscriptionManager.swift
//  PetReminder
//
//  Created by Fran Alarza on 22/10/24.
//

import Foundation
import RevenueCat
import Combine

final class SubscriptionManager: NSObject, PurchasesDelegate {
    
    @Published private(set) var isSubscribed: Bool = false
    
    var subscribePublisher: AnyPublisher<Bool, Never> {
        return $isSubscribed.eraseToAnyPublisher()
    }
    
    func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
        guard let entitlement = customerInfo.entitlements.all["Pet Buddy Pro"] else {
            isSubscribed = false
            return
        }
        
        isSubscribed = entitlement.isActive
    }
}
