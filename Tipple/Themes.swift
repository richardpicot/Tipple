// Themes.swift
// Tipple
//
// Created by Richard Picot on 10/09/2023.
//

import Foundation
import SwiftUI

struct Theme {
    var colorScheme: ColorScheme
        
    init(colorScheme: ColorScheme) {
        self.colorScheme = colorScheme
    }
    
    // Label primary color in Display P3 color space
    var labelPrimary: Color {
        let uiColor = (colorScheme == .dark) ? UIColor(displayP3Red: 1, green: 0.74, blue: 0.42, alpha: 1) : UIColor(displayP3Red: 0.54, green: 0, blue: 0.34, alpha: 1)
        return Color(uiColor)
    }
    
    // Background primary gradient
    var backgroundGradientPrimary: LinearGradient {
        let colors = colorScheme == .dark ?
            [UIColor(displayP3Red: 0.12, green: 0.02, blue: 0.08, alpha: 1),
             UIColor(displayP3Red: 0.1, green: 0.02, blue: 0.07, alpha: 1)] :
            [UIColor(displayP3Red: 0.96, green: 0.92, blue: 0.84, alpha: 1),
             UIColor(displayP3Red: 0.96, green: 0.88, blue: 0.72, alpha: 1)]
        
        return LinearGradient(gradient: Gradient(colors: colors.map { Color($0) }),
                              startPoint: .top,
                              endPoint: .bottom)
    }
    
    // Background secondary gradient
    var backgroundGradientSecondary: LinearGradient {
        let colors = colorScheme == .dark ?
            [UIColor(displayP3Red: 0.4, green: 0.06, blue: 0.28, alpha: 1),
             UIColor(displayP3Red: 0.25, green: 0.01, blue: 0.15, alpha: 1)] :
        [UIColor(displayP3Red: 0.97, green: 0.82, blue: 0.44, alpha: 1),
             UIColor(displayP3Red: 0.93, green: 0.6, blue: 0.25, alpha: 1)]
        
        return LinearGradient(gradient: Gradient(colors: colors.map { Color($0) }),
                              startPoint: .top,
                              endPoint: .bottom)
    }
    
    // Button primary color in Display P3 color space
    var buttonPrimary: Color {
        let uiColor = (colorScheme == .dark) ? UIColor(displayP3Red: 0.9607843137, green: 0.9098039216, blue: 0.8078431373, alpha: 1) : UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1)
        return Color(uiColor)
    }
    
    // Button secondary color in Display P3 color space
    var buttonSecondary: Color {
        let uiColor = (colorScheme == .dark) ? UIColor(displayP3Red: 0.3882352941, green: 0.0862745098, blue: 0.3215686275, alpha: 1) : UIColor(displayP3Red: 0.9725490196, green: 0.7764705882, blue: 0.4784313725, alpha: 1)
        return Color(uiColor)
    }
}
