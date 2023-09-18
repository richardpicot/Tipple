//
//  ContentView.swift
//  Tipple
//
//  Created by Richard Picot on 25/06/2023.
//
import SwiftUI
import SwiftData
import TipKit

struct DrinkCountView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var appSettings: AppSettings
    @Environment(\.colorScheme) var colorScheme
    
    @Query(sort: \DrinkEntry.dateAdded, order: .forward, animation: .default)
    
    var drinks: [DrinkEntry]
    
    @State private var showingHistory = false
    @State private var showingSettings = false
    @State private var showingLogDrinkForm = false
    @State private var animatedDrinksThisWeek: Int = 0
    @State private var showDrinkAnimation = false
    @State private var isPressed = false
    
    var logDrinkTip = LogDrinkTip()
    
    private var drinksThisWeek: Int {
        var calendar = Calendar.current
        calendar.firstWeekday = Weekday.allCases.firstIndex(of: Weekday(rawValue: appSettings.weekStartDay.rawValue)!)! + 1

        let now = Date()
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
        
        let range = startOfWeek...endOfWeek
        
        return drinks.filter {
            let drinkDate = calendar.startOfDay(for: $0.dateAdded)
            return range.contains(drinkDate)
        }.reduce(0) {
            $0 + $1.numberOfDrinks
        }
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
    
    private func updateAnimatedDrinksThisWeek() {
        withAnimation {
            self.animatedDrinksThisWeek = drinksThisWeek
        }
    }
    
    
    var body: some View {
        let theme = Theme(colorScheme: colorScheme)
        
        NavigationView {
            ZStack {
                // Surface gradient
                theme.backgroundGradientPrimary.ignoresSafeArea()
                
                BackgroundView(progress: CGFloat(animatedDrinksThisWeek) / CGFloat(appSettings.drinkLimit))
                
                VStack {
                    Spacer()
                    
                    Text("\(animatedDrinksThisWeek)")
                        .font(.system(size: 80))
                        .foregroundColor(theme.labelPrimary)
                        .fontWeight(.semibold)
                        .contentTransition(.numericText(value: Double(animatedDrinksThisWeek)))
                        .onAppear {
                            updateAnimatedDrinksThisWeek()
                        }
                        .onChange(of: drinks) {
                            updateAnimatedDrinksThisWeek()
                        }
                    
                    VStack {
                        Text(drinksThisWeek == 1 ? "Drink this week." : "Drinks this week.")
                        
                        if drinksRemaining > 0 {
                            Text("\(drinksRemaining) more until you reach your limit.")
                        } else if drinksThisWeek == appSettings.drinkLimit {
                            Text("You've reached your limit.")
                        } else {
                            Text("You're \(drinksOverLimit) over your weekly limit.")
                        }
                    }
                    .font(.body)
                    .foregroundStyle(theme.labelPrimary)
                    .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    //Buttons
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            showingSettings = true
                        }) {
                            Image(systemName: "gear")
                                .font(.system(size: 18, weight: .semibold))
                        }
                        .sheet(isPresented: $showingSettings) {
                            SettingsView()
                                .presentationDetents([.medium, .large])
                        }
                        .frame(minWidth: 44, minHeight: 44)
                        .background(theme.buttonSecondary)
                        .clipShape(Circle())
                        
                        Spacer()

                        // Add drink button
//                        LogDrinkButtonView(showingLogDrinkForm: $showingLogDrinkForm)
//                            .sheet(isPresented: $showingLogDrinkForm, onDismiss: {appSettings.hasShownLogDrinkForm = true
//                            }) {
//                                LogDrinkFormView()
//                            }
//                            .popoverTip(LogDrinkTip(), arrowEdge: .bottom)
                        
                        Button {
                            // empty action
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 28))
                        }
                        .simultaneousGesture(LongPressGesture().onChanged { _ in
                            print("Tap started")
                            isPressed = true
                        })
                        .simultaneousGesture(LongPressGesture().onEnded { _ in
                            print("Long press")
                            isPressed = false
                            showingLogDrinkForm = true
                        })
                        .simultaneousGesture(TapGesture().onEnded {
                            print("Button tap logged")
                            LogDrinkTip.isActive = true
                            isPressed = false
                            let drink = DrinkEntry(dateAdded: .now, numberOfDrinks: 1)
                            modelContext.insert(drink)
                        })
                        .frame(minWidth: 80, minHeight: 80)
                        .background(.white)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.06), radius: 20, x: 0, y: 10)
                        .shadow(color: .labelPrimary.opacity(0.05), radius: 20, x: 0, y: 10)
                        .scaleEffect(isPressed ? 0.85 : 1)
                        .animation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0), value: isPressed)
                        .popoverTip(LogDrinkTip(), arrowEdge: .bottom)
                        .sheet(isPresented: $showingLogDrinkForm, content: {
                            LogDrinkFormView()
                        })
                        
                        Spacer()
                        
                        Button(action: {
                            showingHistory = true
                        }) {
                            Image(systemName: "list.bullet")
                                .font(.system(size: 18, weight: .semibold))
                        }
                        .sheet(isPresented: $showingHistory) {
                            HistoryView()
                                .presentationDetents([.medium, .large])
                                .background(.thinMaterial)
                        }
                        .frame(minWidth: 44, minHeight: 44)
                        .background(theme.buttonSecondary)
                        .clipShape(Circle())
                        
                        Spacer()
                    }
                }
            }
        }
        .onAppear {
            updateAnimatedDrinksThisWeek()
        }
        .onChange(of: drinks) {
            updateAnimatedDrinksThisWeek()
        }
        .onChange(of: appSettings.weekStartDay) {
            updateAnimatedDrinksThisWeek()
        }
        .task {
            // Configure and load your tips at app launch.
            try? Tips.configure([
                .displayFrequency(.immediate),
                .datastoreLocation(.applicationDefault)
            ])
        }
        .accentColor(theme.labelPrimary)
        .fontDesign(.rounded)
    }
}

#Preview {
    DrinkCountView()
        .environmentObject(AppSettings.shared)
}
