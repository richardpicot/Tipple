//
//  Drink.swift
//  Tipple
//
//  Created by Richard Picot on 25/06/2023.
//

import Foundation
import SwiftData

@Model
class DrinkEntry {
    let id: UUID
    let dateAdded: Date
    let numberOfDrinks: Int
    
    init(dateAdded: Date, numberOfDrinks: Int) {
        self.id = UUID()
        self.dateAdded = dateAdded
        self.numberOfDrinks = numberOfDrinks
    }
}
