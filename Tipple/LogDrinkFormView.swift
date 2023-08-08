//
//  LogDrinkFormView.swift
//  Tipple
//
//  Created by Richard Picot on 04/08/2023.
//

import SwiftUI

struct LogDrinkFormView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var numberOfDrinks = ""
    @State private var date = Date()
    @State private var time = Date()
    @FocusState private var drinksFocus: Bool
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Drinks", text: $numberOfDrinks)
                        .focused($drinksFocus)
                        .keyboardType(.numberPad)
                }
                
                Section {
                    DatePicker("Date",
                               selection: $date,
                               displayedComponents: .date)
                    
                    DatePicker("Time",
                               selection: $time,
                               displayedComponents: .hourAndMinute)
                }
            }
            .navigationBarTitle("Log drinks", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Log") {
                        if let numberOfDrinks = Double(numberOfDrinks) {
                            var calendar = Calendar.current
                            calendar.timeZone = TimeZone.current
                            
                            let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
                            let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
                            
                            if let combinedDate = calendar.date(from: DateComponents(calendar: calendar, timeZone: .current, year: dateComponents.year, month: dateComponents.month, day: dateComponents.day, hour: timeComponents.hour, minute: timeComponents.minute)) {
                                for _ in 0..<Int(numberOfDrinks) {
                                    let drink = Drink(dateAdded: combinedDate, amount: 1)
                                    modelContext.insert(drink)
                                }
                                dismiss()
                            }
                        }
                    }
                    .disabled(numberOfDrinks.isEmpty)
                    .fontWeight(.bold)
                }
            }
        }
        .onAppear {
            drinksFocus = true
        }
    }
}

#Preview {
    LogDrinkFormView()
}
