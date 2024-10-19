//
//  HapticFeedbackManager.swift
//  PetReminder
//
//  Created by Fran Alarza on 19/10/24.
//

import Foundation
import UIKit

final class HapticFeedbackManager {
    static let shared = HapticFeedbackManager()
    
    private init() {}
    
    enum HapticFeedbackType: Int {
        case success
        case warning
        case error
    }
    
    func playHapticFeedback(type: HapticFeedbackType) {
        switch type {
        case .success:
            successHapticFeedback()
        case .warning:
            warningHapticFeedback()
        case .error:
            errorHapticFeedback()
        }
    }
    
    private func successHapticFeedback() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    
    private func warningHapticFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
    
    private func errorHapticFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
}
