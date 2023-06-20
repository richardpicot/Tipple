//
//  DrinkItem.swift
//  Tipple
//
//  Created by Richard Picot on 19/06/2023.
//

import Foundation
import SwiftData

@Model
class DrinkItem: Identifiable {
    let id = UUID()
    let date: Date
    let amount: Double
    
    init(date: Date, amount: Double) {
            self.date = date
            self.amount = amount
        }
}
