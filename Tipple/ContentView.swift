//
//  ContentView.swift
//  Tipple
//
//  Created by Richard Picot on 16/06/2023.
//
import SwiftUI
import HealthKit

struct ContentView: View {
    @Environment (\.modelContext) private var context
    @StateObject var drinks = Drinks()
    
    @State private var showingSettings = false
    @State private var showingHistory = false
    @State private var weeklyDrinkLimit = 8
    
    
    var body: some View {
        NavigationView {
            
            //Logic to set a background gradient
            ZStack {
                if drinks.items.count < weeklyDrinkLimit {
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
                    VStack {
                        Text("\(drinks.items.count)")
                            .font(.system(size: 80))
                        // logic to set the color of the count
                            .foregroundColor({
                                if drinks.items.count < weeklyDrinkLimit {
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
                    }
                    
                    Spacer()
                                        
                    Button(action: logDrink) {
                        Label("Log a drink", systemImage: "plus")
                    }
                    .buttonStyle(.bordered)
                    .controlSize(/*@START_MENU_TOKEN@*/.large/*@END_MENU_TOKEN@*/)
                    .buttonBorderShape(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=shape: ButtonBorderShape@*/.capsule/*@END_MENU_TOKEN@*/)
                }
                .navigationBarTitle("Tipple", displayMode: .inline)
                .fontDesign(.rounded)
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
                        showingSettings.toggle()
                    } label: {
                        Image(systemName: "gear")
                    }
                    .sheet(isPresented: $showingSettings) {
                        SettingsView()
                            .presentationDetents([.medium, .large])
                    }
                }
            }
        }
        .environmentObject(drinks)
        .accentColor(.primary)
    }
    
    func logDrink() {
//        let drink = DrinkItem(date: .now, amount: 1)
//        drinks.items.append(drink)
//        print(drinks.items.count)
        
        // New SwiftData on
        let drink = DrinkItem(date: .now, amount: 1)
        context.insert(drink)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(drinks: Drinks())
    }
}
