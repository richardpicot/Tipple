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
    
    @State private var drinkLogged = false
    @State private var numberOfDrinks = ""
    @State private var date = Date()
    @State private var time = Date()
    @FocusState private var drinksFocus: Bool
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Text("Drinks")
                        Spacer()
                        TextField("", text: $numberOfDrinks)
                            .focused($drinksFocus)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }

                VStack {
                    DatePicker("Date",
                               selection: $date,
                               in: ...Date(),
                               displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    
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
                    Button("Save") {
                        if let numberOfDrinksInt = Int(numberOfDrinks) {
                            var calendar = Calendar.current
                            calendar.timeZone = TimeZone.current
                            
                            let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
                            let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
                            
                            if let combinedDate = calendar.date(from: DateComponents(calendar: calendar, timeZone: .current, year: dateComponents.year, month: dateComponents.month, day: dateComponents.day, hour: timeComponents.hour, minute: timeComponents.minute)) {
                                
                                // Create just one Drink object with the total amount
                                let drink = DrinkEntry(dateAdded: combinedDate, numberOfDrinks: numberOfDrinksInt)
                                modelContext.insert(drink)
                                
                                drinkLogged = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    drinkLogged = false
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
        .sensoryFeedback(.impact(), trigger: drinkLogged)
    }
}

#Preview {
    LogDrinkFormView()
}
