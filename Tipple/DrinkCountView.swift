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
    
    @Query(sort: \Drink.dateAdded, order: .forward, animation: .default)
    
    var drinks: [Drink]
    
    @State private var showingHistory = false
    @State private var showingSettings = false
    @State private var showingLogDrinkForm = false
    @State private var animatedDrinksThisWeek: Int = 0
    @State private var showDrinkAnimation = false
    @State private var isPressed = false

    
    private func updateAnimatedDrinksThisWeek() {
        withAnimation {
            self.animatedDrinksThisWeek = drinksThisWeek
        }
    }
    
    private func startOfWeek(for date: Date, weekStartsOn startDay: String) -> Date {
        var calendar = Calendar.current
        calendar.firstWeekday = startDay == "Sunday" ? 1 : 2 // Sunday is 1, Monday is 2
        return calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
    }

    private var drinksThisWeek: Int {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        let today = calendar.startOfDay(for: Date())

        // Calculate the start of the week based on user's setting
        let startOfWeek = self.startOfWeek(for: today, weekStartsOn: appSettings.weekStartDay)

        var totalDrinksThisWeek = 0
        
        for drink in drinks {
            let drinkDate = calendar.startOfDay(for: drink.dateAdded)
            if drinkDate >= startOfWeek && drinkDate <= today {
                totalDrinksThisWeek += drink.amount // Sum up the 'amount' for each Drink object
            }
        }
        
        return totalDrinksThisWeek
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
                // Surface gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 0.96, green: 0.92, blue: 0.84), Color(red: 0.96, green: 0.88, blue: 0.72)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                BackgroundView(progress: CGFloat(animatedDrinksThisWeek) / CGFloat(appSettings.drinkLimit))
                
                VStack {
                    Spacer()
                    
                    Text("\(animatedDrinksThisWeek)")
                        .font(.system(size: 80))
                        .foregroundColor(.labelPrimary)
                        .fontWeight(.semibold)
                        .contentTransition(.numericText())
                        .onAppear {
                            updateAnimatedDrinksThisWeek()  // <---- Add this
                        }
                        .onChange(of: drinks) {
                            updateAnimatedDrinksThisWeek()
                        }
                    
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
                    .foregroundStyle(.labelPrimary)
                    
                    Spacer()
                    
                    //Buttons
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            showingSettings = true
                        }) {
                            Image(systemName: "gear")
                                .font(.body.bold())
                                .frame(width: 36, height: 36)
                        }
                        .sheet(isPresented: $showingSettings) {
                            SettingsView()
                                .presentationDetents([.medium, .large])
                        }
                        .background(Color(red: 0.97, green: 0.78, blue: 0.48))
                        .clipShape(Circle())
                        
                        Spacer()
                        
                        // Add drink button
                        AddDrinkButton(showingLogDrinkForm: $showingLogDrinkForm)
                            .sheet(isPresented: $showingLogDrinkForm) {
                                LogDrinkFormView()
                            }
                        
                        Spacer()
                        
                        Button(action: {
                            showingHistory = true
                        }) {
                            Image(systemName: "list.bullet")
                                .font(.body.bold())
                                .frame(width: 36, height: 36)
                        }
                        .sheet(isPresented: $showingHistory) {
                            HistoryView()
                                .presentationDetents([.medium, .large])
                                .background(.thinMaterial)
                        }
                        .background(Color(red: 0.97, green: 0.78, blue: 0.48))
                        .clipShape(Circle())
                        
                        Spacer()
                    }
                }
            }
        }
        .accentColor(.labelPrimary)
        .fontDesign(.rounded)
    }
}

#Preview {
    DrinkCountView()
        .environmentObject(AppSettings.shared)
}
