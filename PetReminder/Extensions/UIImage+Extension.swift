//
//  UIImage+Extension.swift
//  PetReminder
//
//  Created by Fran Alarza on 11/10/24.
//

import Foundation
import UIKit

extension UIImage {
    func convertImageToBase64String(format: ImageFormat = .jpeg(compressionQuality: 0.7)) -> String? {
        var imageData: Data?
        switch format {
        case .png:
            imageData = self.pngData()
        case .jpeg(let compressionQuality):
            imageData = self.jpegData(compressionQuality: compressionQuality)
        }
        
        return imageData?.base64EncodedString()
    }
}

enum ImageFormat {
    case png
    case jpeg(compressionQuality: CGFloat)
}
