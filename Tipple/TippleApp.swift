//
//  TippleApp.swift
//  Tipple
//
//  Created by Richard Picot on 25/06/2023.
//

import SwiftUI

@main
struct TippleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Drink.self)
        }
    }
}
