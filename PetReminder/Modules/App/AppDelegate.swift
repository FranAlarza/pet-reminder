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
import Shake

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      Shake.start(apiKey: "cGkuIC8HPfcu2RYOXzuHOUSY1YldwQb7meKUQIVICLO65V7Qmnqh9om")
      FirebaseApp.configure()
      Analytics.setAnalyticsCollectionEnabled(true)
      Analytics.logEvent("app_started", parameters: ["param_appEvent":"appInit"])
    return true
  }
}
