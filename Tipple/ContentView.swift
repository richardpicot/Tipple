//
//  ContentView.swift
//  Tipple
//
//  Created by Richard Picot on 16/06/2023.
//
import SwiftUI
import HealthKit

struct ContentView: View {
    
    @State private var showingSettings = false
    @State private var showingHistory = false
    
    @State private var drinkCount = 0
    @State private var weeklyDrinkLimit = 8
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                VStack {
                    Text("\(drinkCount)")
                        .font(.system(size: 80))
                        .foregroundColor({
                                if drinkCount >= weeklyDrinkLimit {
                                    return .orange
                                } else {
                                    return .primary
                                }
                    }())

                    Text("drinks this week")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
                Spacer()
                
                Button(action: logDrink) {
                        Label("Log a drink", systemImage: "plus")
                    }
                .buttonStyle(.borderedProminent)
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
    
    func logDrink() {
        drinkCount += 1
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
