//
//  CLEApp.swift
//  CLE
//
//  Created by 神宮一敬 on 2024/12/13.
//

import SwiftUI





class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
}



@main
struct CLEApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
