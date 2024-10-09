//
//  Global.swift
//  PetReminder
//
//  Created by Fran Alarza on 9/10/24.
//

import Foundation
import FirebaseAuth

struct Global {
    // static var that returns the uid if the user is autheticated
    static var userId: String? {
        if let id = Auth.auth().currentUser?.uid {
            return id
        } else {
            return nil
        }
    }
}
