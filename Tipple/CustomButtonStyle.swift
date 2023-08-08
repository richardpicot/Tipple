//
//  CustomButtonStyle.swift
//  Tipple
//
//  Created by Richard Picot on 24/07/2023.
//

import Foundation
import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool
    var isOverLimit: Bool

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.body)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .background(isOverLimit ? Color.orange : Color.green)
            .cornerRadius(40)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .brightness(configuration.isPressed ? 0.1 : 0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

