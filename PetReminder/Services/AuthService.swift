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
            let userId = try await Auth.auth().signInAnonymously().user.uid
            let userExist = try await Firestore.firestore().collection("users").whereField("id", isEqualTo: userId).getDocuments()
            if userExist.isEmpty {
                await register(userId: userId)
            } else {
                print("User already registered")
            }
        } catch {
            print("Error logging in user: \(error)")
        }
    }
    
    private func register(userId: String) async {
        do {
            let data = try await Auth.auth().signInAnonymously()
            let dto = RegisterDto(id: data.user.uid)
            let endpoint = AuthEndpoints.register(dto)
            try await FirestoreService.request(endpoint)
        } catch {
            print("Error registering user: \(error)")
        }
    }
}
