//
//  DrinkItem.swift
//  Tipple
//
//  Created by Richard Picot on 19/06/2023.
//

import Foundation

struct DrinkItem: Identifiable {
    let id = UUID()
    let date: Date
    let amount: Double
}
