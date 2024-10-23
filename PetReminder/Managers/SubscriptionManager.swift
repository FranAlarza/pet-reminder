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
    
    static let shared = SubscriptionManager()
    
    @Published private(set) var isSubscribed: Bool = false
    
    var subscribePublisher: AnyPublisher<Bool, Never> {
        return $isSubscribed.eraseToAnyPublisher()
    }
    
    override init() {
        super.init()
    }
    
    func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
        guard let entitlement = customerInfo.entitlements.all["pro"] else {
            isSubscribed = false
            return
        }
        
        isSubscribed = entitlement.isActive
    }
}
