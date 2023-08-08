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
    @EnvironmentObject private var appSettings: AppSettings
    
    // Use index of this array to work out which day is set
    let days = ["Sunday", "Monday"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Week starts on", selection: $appSettings.weekStartDay) {
                        ForEach(days, id: \.self) {
                            Text("\($0)")
                        }
                    }
                    Picker("Weekly limit", selection: $appSettings.drinkLimit) {
                        ForEach(0..<15) {
                            Text("\($0) drinks")
                        }
                    }
                } footer: {
                    Text("It's recommended to drink no more than 14 units of alcohol a week. That's around 6 medium glasses of wine, or 6 pints of 4% beer.")
                }
            }
            .navigationBarTitle("Settings", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                                dismiss()
                            }) {
                                Text("Done").bold()
                            })
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppSettings.shared)
}
