//
//  AppDelegate.swift
//  PetReminder
//
//  Created by Fran Alarza on 9/10/24.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseAnalytics
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()
    return true
  }
}
