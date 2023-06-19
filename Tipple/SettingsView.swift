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
    
    @State private var weeklyDrinkLimit = 8
    @State private var weekStartDay = "Monday"
    @State private var syncWithHealth = false
    
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
                    Toggle("Sync with Apple Health", isOn: $syncWithHealth)
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
