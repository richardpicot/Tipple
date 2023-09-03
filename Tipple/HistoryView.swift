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
    @Environment(\.dismiss) var dismiss
    
    @Query(sort: \Drink.dateAdded, order: .reverse)
    var drinks: [Drink]
    
    private var isListEmpty: Bool {
        return drinks.isEmpty
    }
    
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
    
    var body: some View {
        NavigationView {
            // Wrap the conditional content inside a Group
            Group {
                // conditional for empty state
                if isListEmpty {
                    Text("No drinks logged")
                        .font(.title2)
                        .foregroundColor(Color.secondary)
                        .fontWeight(.semibold)
                } else {
                    // show list of drinks
//                    List(drinks) { drink in
//                        Text(drink.dateAdded.formatted(date: .long, time: .shortened))
                    List(drinks) { drink in
                                            HStack {
                                                Text(formatDate(drink.dateAdded))
                                                Spacer()
                                                Text("\(drink.amount)")
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
            .navigationBarTitle("History", displayMode: .inline) // Apply to Group
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
}


#Preview {
    HistoryView()
}
