//
//  TippleApp.swift
//  Tipple
//
//  Created by Richard Picot on 25/06/2023.
//

import SwiftUI

@main
struct TippleApp: App {
    let appSettings = AppSettings.shared
    
    init() {
            // Load the stored values from UserDefaults
            appSettings.weekStartDay = UserDefaults.standard.string(forKey: "weekStartDay") ?? "Monday"
            appSettings.drinkLimit = UserDefaults.standard.integer(forKey: "drinkLimit")
        }
    
    var body: some Scene {
        WindowGroup {
            DrinkCountView()
                .modelContainer(for: Drink.self)
                .environmentObject(appSettings)
        }
    }
}
