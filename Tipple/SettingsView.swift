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
    
    let days = ["Sunday", "Monday"]
    
    var body: some View {
        NavigationView{
            Form {
                Section {
                    Picker("Weekly limit", selection: $appSettings.drinkLimit) {
                        ForEach(0..<15) {
                            Text("\($0) drinks")
                        }
                    }
                    Picker("Week starts on", selection: $appSettings.weekStartDay) {
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
        .environmentObject(AppSettings.shared)
}
