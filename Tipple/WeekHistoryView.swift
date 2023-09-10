//
//  WeekDetailView.swift
//  Tipple
//
//  Created by Richard Picot on 03/09/2023.
//

import SwiftUI
import SwiftData

// Function to format the date
func formatDate(_ date: Date) -> String {
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: Date())
    let drinkDate = calendar.startOfDay(for: date)
    
    if today == drinkDate {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mma"
        var timeString = timeFormatter.string(from: date)
        timeString = timeString.replacingOccurrences(of: "AM", with: "am").replacingOccurrences(of: "PM", with: "pm")
        return "Today at \(timeString)"
    } else {
        let formatter = DateFormatter()
        formatter.dateFormat = "E d MMM 'at' h:mma"
        var formattedString = formatter.string(from: date)
        formattedString = formattedString.replacingOccurrences(of: "AM", with: "am").replacingOccurrences(of: "PM", with: "pm")
        return formattedString
    }
}

struct WeekHistoryView: View {
    var weekStart: Date
    var weekDrinks: [DrinkEntry]
    @Environment(\.modelContext) private var modelContext

    // Your existing formatDate function can be used here if needed

    var body: some View {
            List {
                Section() {
                    ForEach(weekDrinks, id: \.id) { drink in
                        HStack {
                            Text(formatDate(drink.dateAdded))
                            Spacer()
                            Text("\(drink.numberOfDrinks)")
                                .foregroundColor(.gray)
                        }
                        .swipeActions {
                            Button("Delete", role: .destructive) {
                                modelContext.delete(drink)
                                print("Drink deleted.")
                            }
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Details", displayMode: .inline)
        }
}
