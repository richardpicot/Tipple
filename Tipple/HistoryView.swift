//
//  HistoryView.swift
//  Tipple
//
//  Created by Richard Picot on 25/06/2023.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.locale) private var locale: Locale
    @Environment(\.dismiss) var dismiss
    @ObservedObject var appSettings = AppSettings.shared
    

    
    @Query(sort: \DrinkEntry.dateAdded, order: .reverse)
    var drinks: [DrinkEntry]
    
    private var isListEmpty: Bool {
        return drinks.isEmpty
    }
    
    func formatDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let drinkDate = calendar.startOfDay(for: date)
        
        let formatter = DateFormatter()
        formatter.locale = Locale.current // Use the current user's locale

        if today == drinkDate {
            formatter.setLocalizedDateFormatFromTemplate("h:mm a") // This will take into account user locale for time
            var timeString = formatter.string(from: date)
            timeString = timeString.replacingOccurrences(of: "AM", with: "am").replacingOccurrences(of: "PM", with: "pm")
            return "Today at \(timeString)"
        } else {
            formatter.setLocalizedDateFormatFromTemplate("EEE d MMM h:mm a") // This will take into account user locale for day, date, and month
            var formattedString = formatter.string(from: date)
            formattedString = formattedString.replacingOccurrences(of: "AM", with: "am").replacingOccurrences(of: "PM", with: "pm")
            return formattedString
        }
    }

    
    
    // Function to decide if the entry is from the current week
    private func isCurrentWeek(entryDate: Date) -> Bool {
        let calendar = Calendar.current
        var adjustedCalendar = calendar
        adjustedCalendar.firstWeekday = Weekday.allCases.firstIndex(of: appSettings.weekStartDay)! + 1 // Update first weekday

        let today = Date()

        // Calculate the start of the current week and the entry week
        let currentWeekStart = adjustedCalendar.date(from: adjustedCalendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        let entryWeekStart = adjustedCalendar.date(from: adjustedCalendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: entryDate))!

        return currentWeekStart == entryWeekStart
    }
    
    // Add this function to HistoryView to check if there are entries for the current week
    private func hasEntriesForCurrentWeek() -> Bool {
        for drink in drinks {
            if isCurrentWeek(entryDate: drink.dateAdded) {
                return true
            }
        }
        return false
    }
    
    // Add this function to your existing HistoryView to check if there are entries for previous weeks
    private func hasEntriesForPreviousWeeks() -> Bool {
        for (weekStart, _, _) in groupedDrinks {
            if !isCurrentWeek(entryDate: weekStart) {
                return true
            }
        }
        return false
    }

    private var groupedDrinks: [(Date, [DrinkEntry], Int)] {
        let calendar = Calendar.current
        var adjustedCalendar = calendar
        adjustedCalendar.firstWeekday = Weekday.allCases.firstIndex(of: appSettings.weekStartDay)! + 1 // Update first weekday

        var grouped: [Date: [DrinkEntry]] = [:]
        
        for drink in drinks {
            let components = adjustedCalendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: drink.dateAdded)
            if let startOfWeek = adjustedCalendar.date(from: components) {
                if grouped[startOfWeek] == nil {
                    grouped[startOfWeek] = []
                }
                grouped[startOfWeek]?.append(drink)
            }
        }

        return grouped.sorted(by: { $0.0 > $1.0 }).map { (date, entries) in
            // Calculate the total number of drinks for the week
            let totalDrinks = entries.reduce(0) { $0 + $1.numberOfDrinks }
            return (date, entries, totalDrinks)
        }
    }

    
    var body: some View {
            NavigationView {
                List {
                    // Current week section
                    Section(header: hasEntriesForCurrentWeek() ? Text("This Week") : nil) {
                        ForEach(drinks) { drink in
                            if isCurrentWeek(entryDate: drink.dateAdded) {
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
                    
                    Section(header: hasEntriesForPreviousWeeks() ? Text("Previous Weeks") : nil) {
                        ForEach(groupedDrinks, id: \.0) { (weekStart, weekDrinks, totalDrinks) in
                            if !isCurrentWeek(entryDate: weekStart) {
                                NavigationLink(destination: WeekHistoryView(weekStart: weekStart, weekDrinks: weekDrinks)) {
                                    HStack {
                                        Text(weekStart, style: .date)
                                        Spacer()
                                        Text("\(totalDrinks)")  // Changed to totalDrinks to display total number of drinks
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle("History", displayMode: .inline)
                .toolbar {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Done").bold()
                    }
                }
            }
            .fontDesign(.rounded)
        }
     
     private func entryRow(for drink: DrinkEntry) -> some View {
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


#Preview {
    HistoryView()
}
