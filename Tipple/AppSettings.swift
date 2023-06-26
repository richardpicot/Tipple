//
//  AppSettings.swift
//  Tipple
//
//  Created by Richard Picot on 26/06/2023.
//

import Foundation

class AppSettings: ObservableObject {
    @Published var weekStartDay = UserDefaults.standard.string(forKey: "weekStartDay") ?? "Monday" {
        didSet {
            UserDefaults.standard.set(weekStartDay, forKey: "weekStartDay")
        }
    }
    
    @Published var drinkLimit = UserDefaults.standard.integer(forKey: "drinkLimit") {
        didSet {
            UserDefaults.standard.set(drinkLimit, forKey: "drinkLimit")
        }
    }

    static let shared = AppSettings()
    
    private init() {
        // If user defaults haven't been set for drinkLimit set it to 8 as a default
        self.drinkLimit = UserDefaults.standard.integer(forKey: "drinkLimit")
                if self.drinkLimit == 0 {
                    self.drinkLimit = 8
                }
    }
}
