//
//  UIApplication+Extension.swift
//  PetReminder
//
//  Created by Fran Alarza on 11/10/24.
//

import Foundation
import UIKit

extension UIApplication {
    func dismissKeyboard() {
        self.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
