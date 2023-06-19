//
//  Drinks.swift
//  Tipple
//
//  Created by Richard Picot on 19/06/2023.
//

import Foundation

class Drinks : ObservableObject {
    @Published var items = [DrinkItem]()
}
