//
//  AppSettings.swift
//  Tipple
//
//  Created by Richard Picot on 26/06/2023.
//

import Foundation

enum Weekday: String, CaseIterable, Identifiable {
    case sunday, monday, tuesday, wednesday, thursday, friday, saturday
    
    var id: String { self.rawValue }
    var displayName: String { self.rawValue.capitalized }
}

class AppSettings: ObservableObject {
    // Using Weekday enum to define the weekStartDay
    @Published var weekStartDay: Weekday {
        didSet {
            // Saving to UserDefaults
            UserDefaults.standard.set(weekStartDay.rawValue, forKey: "weekStartDay")
        }
    }
    
    @Published var drinkLimit: Int {
        didSet {
            // Saving to UserDefaults
            UserDefaults.standard.set(drinkLimit, forKey: "drinkLimit")
        }
    }
    
    @Published var hasShownLogDrinkForm: Bool {
        didSet {
            // Saving to UserDefaults
            UserDefaults.standard.set(hasShownLogDrinkForm, forKey: "hasShownLogDrinkForm")
        }
    }
    
    static let shared = AppSettings()
    
    private init() {
        // Initializing weekStartDay from UserDefaults
        if let savedWeekStartDay = UserDefaults.standard.string(forKey: "weekStartDay"),
           let weekday = Weekday(rawValue: savedWeekStartDay) {
            self.weekStartDay = weekday
        } else {
            self.weekStartDay = .sunday // Default value
        }
        
        // Initializing drinkLimit from UserDefaults
        self.drinkLimit = UserDefaults.standard.integer(forKey: "drinkLimit")
        
        // Initializing hasShownLogDrinkForm from UserDefaults
        self.hasShownLogDrinkForm = UserDefaults.standard.bool(forKey: "hasShownLogDrinkForm")
        
        // Default value if not set
        if self.drinkLimit == 0 {
            self.drinkLimit = 6
        }
    }
}
