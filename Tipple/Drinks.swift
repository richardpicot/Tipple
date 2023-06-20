//
//  Drinks.swift
//  Tipple
//
//  Created by Richard Picot on 19/06/2023.
//

import Foundation

// Dont need this with SwiftData
class Drinks : ObservableObject {
    @Published var items = [DrinkItem]()
}
