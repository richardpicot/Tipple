//
//  Drink.swift
//  Tipple
//
//  Created by Richard Picot on 25/06/2023.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class Drink {
    var id: UUID
    var dateAdded: Date
    var amount: Double
    
    init(dateAdded: Date, amount: Double) {
        self.id = UUID()
        self.dateAdded = dateAdded
        self.amount = amount
    }
}
