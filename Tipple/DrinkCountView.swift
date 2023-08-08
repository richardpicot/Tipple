//
//  ContentView.swift
//  Tipple
//
//  Created by Richard Picot on 25/06/2023.
//
import SwiftUI
import SwiftData

struct DrinkCountView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var appSettings: AppSettings
    
    @Query(sort: \Drink.dateAdded, order: .forward)
    
    var drinks: [Drink]
    
    @State private var showingHistory = false
    @State private var showingSettings = false
    @State private var showingLogDrinkForm = false
//    @State private var weeklyLimit = 8
    
    private var drinksThisWeek: Int {
        var calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        calendar.firstWeekday = 2 // Sunday 1, Monday is 2
        //TODO: Test the above
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        
        let drinksThisWeek = drinks.filter { drink in
            let drinkDate = calendar.startOfDay(for: drink.dateAdded)
            return calendar.isDate(drinkDate, inSameDayAs: today) || (drinkDate >= startOfWeek && drinkDate < today)
        }
        return drinksThisWeek.count
    }
    
    private var drinksRemaining: Int {
        let remaining = appSettings.drinkLimit - drinksThisWeek
        return max(remaining, 0) // Use max to ensure it never goes below 0
    }
    
    private var drinksOverLimit: Int {
        let over = drinksThisWeek - appSettings.drinkLimit
        return max(over, 0) // Use max to ensure it never goes below 0
    }
    
    private var overLimit: Bool {
        return drinksThisWeek >= appSettings.drinkLimit
    }
        
    
    var body: some View {
        NavigationView {
            ZStack {
                //Logic to set a background gradient
                
                if overLimit {
                    LinearGradient(
                        gradient: Gradient(colors: [Color.orange.opacity(0.4), Color.orange.opacity(0.3)]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    .ignoresSafeArea()
                } else {
                    LinearGradient(
                        gradient: Gradient(colors: [Color.green.opacity(0.4), Color.green.opacity(0.3)]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    .ignoresSafeArea()
                }
                
                VStack {
                    Spacer()
                    
                    Text("\(drinksThisWeek)")
                        .font(.system(size: 80))
                    // logic to set the color of the count
                        .foregroundColor(overLimit ? .orange : .green)
                        .fontWeight(.semibold)
                        .contentTransition(.numericText())
                    
                    VStack {
                        Text("Drinks this week.")
                        
                        if drinksRemaining > 0 {
                            Text("\(drinksRemaining) more until you reach your limit.")
                        } else if drinksThisWeek == appSettings.drinkLimit {
                            Text("You've reached your limit.")
                        } else {
                            Text("You're \(drinksOverLimit) over your weekly limit.")
                        }
                    }
                    .font(.body)
                    .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    // Log a drink button
                    Button {
                        withAnimation {
                            let drink = Drink(dateAdded: .now, amount: 1)
                            modelContext.insert(drink)
                        }
                    } label: {
                        Label("Log a Drink", systemImage: "plus")
                    }
                    .contextMenu {
                        Button {
                            let drink = Drink(dateAdded: .now, amount: 1)
                            modelContext.insert(drink)
                        } label: {
                            Label("Now", systemImage: "plus")
                        }
                        
                        Button {
                            var date = Date().addingTimeInterval(-6 * 60 * 60)
                            // Check if the new date falls into the previous day
                            if Calendar.current.startOfDay(for: date) < Calendar.current.startOfDay(for: Date()) {
                                // If it does, reset the date to the start of today
                                var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
                                components.hour = 0
                                components.minute = 0
                                components.second = 0
                                
                                date = Calendar.current.date(from: components) ?? Date()
                            }
                            
                            let drink = Drink(dateAdded: date, amount: 1)
                            modelContext.insert(drink)
                        } label: {
                            Label("Earlier Today", systemImage: "clock.arrow.circlepath")
                        }
                        
                        Button {
                            // Get the current date.
                                var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
                                // Subtract one day from the current date to get yesterday's date.
                                components.day = components.day! - 1
                                // Set the time to 9pm.
                                components.hour = 21
                                components.minute = 0
                                components.second = 0

                                let date = Calendar.current.date(from: components) ?? Date()

                                let drink = Drink(dateAdded: date, amount: 1)
                                modelContext.insert(drink)
                        } label: {
                            Label("Yesterday Evening", systemImage: "moon")
                        }

                        Button {
                            showingLogDrinkForm = true
                        } label: {
                            Label("More Options...", systemImage: "calendar")
                        }
                    }
                    .buttonStyle(CustomButtonStyle(isOverLimit: overLimit))
                    .padding(.horizontal)
                    .sheet(isPresented: $showingLogDrinkForm) {
                        LogDrinkFormView()
                            .presentationDetents([.large])
                    }

                    
                    // Navigation bar
                    // TODO: Fix spacing of buttons
                    .navigationBarTitle("Tipple", displayMode: .inline)
                    .toolbar {
                        HStack(spacing: 30) { // added to keep button spacing standard
                            Button {
                                showingHistory = true
                            } label: {
                                Image(systemName: "list.bullet")
                            }
                            .buttonStyle(BorderlessButtonStyle()) // hack to fix buttons working
                            .sheet(isPresented: $showingHistory) {
                                HistoryView()
                                    .presentationDetents([.medium, .large])
                            }
                            Button {
                                showingSettings = true
                            } label: {
                                Image(systemName: "gear")
                            }
                            .buttonStyle(BorderlessButtonStyle()) // hack to fix buttons working
                            .sheet(isPresented: $showingSettings) {
                                SettingsView()
                                    .presentationDetents([.medium])
                            }
                        }
                        
                    }
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                }
            }
            
        }
        .accentColor(.primary)
        .fontDesign(.rounded)
    }
}

#Preview {
    DrinkCountView()
        .environmentObject(AppSettings.shared)
}
