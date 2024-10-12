//
//  UIImage+Extension.swift
//  PetReminder
//
//  Created by Fran Alarza on 11/10/24.
//

import Foundation
import UIKit

extension UIImage {
    func convertImageToBase64String() -> String? {
        guard let imageData = self.pngData() else {
            return nil
        }
        let base64String = imageData.base64EncodedString(options: .lineLength64Characters)
        return base64String
    }
}
