//
//  AuthService.swift
//  PetReminder
//
//  Created by Fran Alarza on 9/10/24.
//

import Foundation
import Firebase
import FirebaseAuth

protocol AuthServiceProtocol {
    func login() async
}

final class AuthService: AuthServiceProtocol {
    
    func login() async {
        do {
            AnalitycsManager.shared.log(.loginLaunched)
            let userId = Auth.auth().currentUser?.uid ?? ""
            let userExist = try await Firestore.firestore().collection("users").whereField("id", isEqualTo: userId).getDocuments()
            if !userExist.isEmpty {
                debugPrint("User already registered")
            }
        } catch {
            AnalitycsManager.shared.log(.registerLaunched)
            await register()
        }
    }
    
    private func register() async {
        do {
            let data = try await Auth.auth().signInAnonymously()
            let dto = RegisterDto(id: data.user.uid)
            let endpoint = AuthEndpoints.register(dto)
            try await FirestoreService.request(endpoint)
            debugPrint("User created")
        } catch {
            debugPrint("Error registering user: \(error)")
        }
    }
}
