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
    var amount: Int
    
    init(dateAdded: Date, amount: Int) {
        self.id = UUID()
        self.dateAdded = dateAdded
        self.amount = amount
    }
}

extension Drink {
    var weekOf: Date {
        let calendar = Calendar.current
        let weekOfYear = calendar.component(.weekOfYear, from: self.dateAdded)
        let year = calendar.component(.yearForWeekOfYear, from: self.dateAdded)
        return calendar.date(from: DateComponents(weekOfYear: weekOfYear, yearForWeekOfYear: year))!
    }
}
