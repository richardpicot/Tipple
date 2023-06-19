//
//  SettingsView.swift
//  Tipple
//
//  Created by Richard Picot on 16/06/2023.
//

import SwiftUI
import HealthKit

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var drinks: Drinks
    
    @AppStorage("weeklyDrinkLimit") private var weeklyDrinkLimit = 8
    @AppStorage("weekStartDay") private var weekStartDay = "Monday"
    
    let days = ["Sunday", "Monday"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Weekly limit", selection: $weeklyDrinkLimit) {
                        ForEach(0..<15) {
                            Text("\($0) drinks")
                        }
                    }
                    Picker("Week starts on", selection: $weekStartDay) {
                        ForEach(days, id: \.self) {
                            Text("\($0)")
                        }
                    }
                }
                Section {
                    Button("Clear all drinks", role: .destructive) {
                        drinks.items.removeAll()
                    }
                }
            }
            .navigationBarTitle("Settings", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                                dismiss()
                            }) {
                                Text("Done").bold()
                            })
            .fontDesign(.rounded)
        }
    }
        
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
