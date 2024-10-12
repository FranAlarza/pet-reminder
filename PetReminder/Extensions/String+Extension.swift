//
//  String+Extension.swift
//  PetReminder
//
//  Created by Fran Alarza on 11/10/24.
//

import Foundation
import UIKit

extension String {
    func imageFromBase64() -> UIImage? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return UIImage(data: data)
    }
}
