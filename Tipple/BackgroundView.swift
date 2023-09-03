//
//  ProgressBarView.swift
//  Tipple
//
//  Created by Richard Picot on 31/08/2023.
//

import SwiftUI

struct BackgroundView: View {
    
    let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [Color(red: 0.96, green: 0.92, blue: 0.84), Color(red: 0.96, green: 0.88, blue: 0.72)]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    let progressGradient = LinearGradient(
        gradient: Gradient(colors: [Color(red: 1, green: 0.79, blue: 0.46), Color(red: 0.91, green: 0.58, blue: 0.33)]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    var progress: CGFloat  // A number between 0 and 1
    
    var body: some View {
        GeometryReader { geometry in
            let totalHeight = geometry.size.height
            let totalWidth = geometry.size.width
            let progressHeight = totalHeight * progress
            
            VStack {
                ZStack(alignment: .bottom) {
                    backgroundGradient
                    
                    Rectangle()
                        .fill(progressGradient)
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
