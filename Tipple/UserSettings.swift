//
//  UserSettings.swift
//  Tipple
//
//  Created by Richard Picot on 19/06/2023.
//

import Foundation

//TODO: Move user settings into this data file, set the default values and hook it up to the SettingsView
class UserSettings: ObservableObject {
    
    @Published var weeklyDrinkLimit: Int = UserDefaults.standard.integer(forKey: "weeklyDrinkLimit")
    @Published var weekStartDat: String = UserDefaults.standard.string(forKey: "weekStartDay") ?? "Monday"
    
}
