//
//  ProgressBarView.swift
//  Tipple
//
//  Created by Richard Picot on 31/08/2023.
//

import SwiftUI

struct BackgroundView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var progress: CGFloat  // A number between 0 and 1
    
    var body: some View {
        let theme = Theme(colorScheme: colorScheme) // Initialized your custom Theme

        GeometryReader { geometry in
            let totalHeight = geometry.size.height
            let totalWidth = geometry.size.width
            let progressHeight = totalHeight * progress
            
            VStack {
                ZStack(alignment: .bottom) {
                    theme.backgroundGradientPrimary
                    
                    Rectangle()
                        .fill(theme.backgroundGradientSecondary)
                        .frame(width: totalWidth, height: totalHeight)
                        .mask(
                            VStack {
                                Rectangle().frame(height: progressHeight)
                            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                        )
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    BackgroundView(progress: 0.5)
}
