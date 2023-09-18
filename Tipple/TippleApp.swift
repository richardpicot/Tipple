//
//  TippleApp.swift
//  Tipple
//
//  Created by Richard Picot on 25/06/2023.
//

import SwiftUI
import TipKit

@main
struct TippleApp: App {
    let appSettings = AppSettings.shared

    
    init() {
            // Load the stored values from UserDefaults
            if let storedWeekStartDay = UserDefaults.standard.string(forKey: "weekStartDay"),
               let weekday = Weekday(rawValue: storedWeekStartDay.lowercased()) {
                appSettings.weekStartDay = weekday
            }
            
            // Load drinkLimit
            appSettings.drinkLimit = UserDefaults.standard.integer(forKey: "drinkLimit")
        }
    
    var body: some Scene {
        WindowGroup {
            DrinkCountView()
                .modelContainer(for: DrinkEntry.self)
                .environmentObject(appSettings)
        }
    }
}
