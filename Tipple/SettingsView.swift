//
//  SettingsView.swift
//  Tipple
//
//  Created by Richard Picot on 25/06/2023.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    // TODO: combine DrinkLimit as one variable across Settings and ContentView
    @AppStorage("DrinkLimit") private var weeklyLimit = 8
    @AppStorage("weekStartDay") private var weekStartDay = "Monday"
    
    let days = ["Sunday", "Monday"]
    
    var body: some View {
        NavigationView{
            Form {
                Section {
                    Picker("Weekly limit", selection: $weeklyLimit) {
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
                        // TODO: Work out how to delete all items from model
                    }
                }
            }
            .navigationBarTitle("Settings", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                                dismiss()
                            }) {
                                Text("Done").bold()
                            })
        }
        .fontDesign(.rounded)
    }
}

#Preview {
    SettingsView()
}
