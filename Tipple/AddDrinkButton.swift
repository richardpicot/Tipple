//
//  AddDrinkButtonView.swift
//  Tipple
//
//  Created by Richard Picot on 02/09/2023.
//

import SwiftUI
import SwiftData


struct AddDrinkButton: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var showingLogDrinkForm: Bool
    @State private var isPressed = false
    
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        Image(systemName: "plus")
            .font(.title)
            .padding(24)
            .background(.white)
            .foregroundStyle(.labelPrimary)
            .clipShape(Circle())
            .shadow(color: .black.opacity(0.06), radius: 20, x: 0, y: 10)
            .shadow(color: .labelPrimary.opacity(0.05), radius: 20, x: 0, y: 10)
            .scaleEffect(isPressed ? 0.9 : 1)
            .animation(.spring(duration: 0.2), value: isPressed)
            .onTapGesture {
                feedbackGenerator.prepare()
                feedbackGenerator.impactOccurred()
                print("Button tapped!")
                let drink = Drink(dateAdded: .now, amount: 1)
                modelContext.insert(drink)
            }
            .onLongPressGesture(minimumDuration: 0.5, pressing: { pressing in
                isPressed = pressing
                if pressing {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        if isPressed {
                            feedbackGenerator.prepare()
                            feedbackGenerator.impactOccurred()
                            print("Long press action triggered!")
                            showingLogDrinkForm = true
                        }
                    }
                }
            }) {
                // Empty action, required for onLongPressGesture
            }
    }
}

struct AddDrinkButton_Previews: PreviewProvider {
    @State static var showingLogDrinkForm = false // Create a static @State variable for the preview
    
    static var previews: some View {
        AddDrinkButton(showingLogDrinkForm: $showingLogDrinkForm) // Use it here
    }
}
