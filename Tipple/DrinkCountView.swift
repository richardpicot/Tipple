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
    @State private var weeklyLimit = 8
    
    // TODO: Compute the number of drinks within the current week
    private var drinksThisWeek: Int {
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
            
            let drinksThisWeek = drinks.filter { drink in
                let drinkDate = calendar.startOfDay(for: drink.dateAdded)
                return calendar.isDate(drinkDate, inSameDayAs: today) || (drinkDate >= startOfWeek && drinkDate < today)
            }
            
            return drinksThisWeek.count
        }
    
    var body: some View {
        NavigationView {
            ZStack {
                //Logic to set a background gradient
                if drinksThisWeek < appSettings.drinkLimit {
                    LinearGradient(
                        gradient: Gradient(colors: [Color.green.opacity(0.4), Color.green.opacity(0)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                } else {
                    LinearGradient(
                        gradient: Gradient(colors: [Color.orange.opacity(0.4), Color.green.opacity(0)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                }
                
                VStack {
                    Spacer()
                    Text("\(drinksThisWeek)")
                        .font(.system(size: 80))
                    // logic to set the color of the count
                        .foregroundColor({
                            if drinksThisWeek < appSettings.drinkLimit {
                                return .green
                            } else {
                                return .orange
                            }
                        }())
                        .fontWeight(.medium)
                    
                    Text("drinks this week")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Button {
                        let drink = Drink(dateAdded: .now, amount: 1)
                        modelContext.insert(drink)
                    } label: {
                        Label("Log a drink", systemImage: "plus")
                    }
                    .buttonStyle(.bordered)
                    .controlSize(/*@START_MENU_TOKEN@*/.large/*@END_MENU_TOKEN@*/)
                    .buttonBorderShape(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=shape: ButtonBorderShape@*/.capsule/*@END_MENU_TOKEN@*/)
                    
                    // TODO: Remove when sheets work properly
                    HStack(spacing: 32.0) {
                        Button("History") {
                            showingHistory = true
                        }
                        .sheet(isPresented: $showingHistory) {
                            HistoryView()
                                .presentationDetents([.medium, .large])
                        }
                        Button("Settings") {
                            showingSettings = true
                        }
                        .sheet(isPresented: $showingSettings) {
                            SettingsView()
                                .presentationDetents([.medium, .large])
                        }
                    }
                    .navigationBarTitle("Tipple", displayMode: .inline)
                    .toolbar {
                        Button {
                            showingHistory = true
                        } label: {
                            Image(systemName: "list.bullet")
                        }
                        .sheet(isPresented: $showingHistory) {
                            HistoryView()
                                .presentationDetents([.medium, .large])
                        }
                        Button {
                            showingSettings = true
                        } label: {
                            Image(systemName: "gear")
                        }
                        .sheet(isPresented: $showingSettings) {
                            SettingsView()
                                .presentationDetents([.medium, .large])
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
