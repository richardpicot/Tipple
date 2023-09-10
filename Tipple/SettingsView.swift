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
    @Environment(\.colorScheme) var colorScheme
    
    @State private var showDrinkLimitPicker = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Start week on", selection: $appSettings.weekStartDay) {
                        ForEach(Weekday.allCases) { day in
                            Text(day.displayName).tag(day)
                        }
                    }
                    HStack {
                        Text("Weekly drink limit")
                        Spacer()
                        HStack {
                            Text("\(appSettings.drinkLimit)") + Text(appSettings.drinkLimit == 1 ? " drink" : " drinks")
                        }
                        .foregroundColor(showDrinkLimitPicker ? .accent : .secondary)
                        
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            showDrinkLimitPicker.toggle() // Toggle picker visibility
                        }
                    }
                    
                    if showDrinkLimitPicker { // Show the picker if the state variable is true
                        Picker("Weekly Drink Limit", selection: $appSettings.drinkLimit) {
                            ForEach(1...50, id: \.self) { i in
                                Text("\(i) \(i == 1 ? "drink" : "drinks")").tag(i)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                    }
                } footer: {
                    Text("It's recommended to drink no more than 14 units of alcohol a week. That's around 6 medium glasses of wine, or 6 pints of 4% beer.")
                }
                    
                    //                        Picker("Weekly limit", selection: $appSettings.drinkLimit) {
                    //                            ForEach(0..<15) {
                    //                                Text("\($0) drinks")
                    //                            }
                    //                        }
                
            }
            .navigationBarTitle("Settings", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                dismiss()
            }) {
                Text("Done").bold()
            }.foregroundColor(.orange))
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppSettings.shared)
}
