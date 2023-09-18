//
//  LogDrinkTip.swift
//  Tipple
//
//  Created by Richard Picot on 13/09/2023.
//

import Foundation
import TipKit

struct LogDrinkTip: Tip {
    @Parameter
       static var isActive: Bool = false
    
    
        var title: Text {
            Text("Log drinks by date")
        }
        
        var message: Text? {
            Text("Long press to log multiple drinks for different days.")
        }
        
        var image: Image? {
            Image(systemName: "calendar.badge.plus")
        }
    
    var rules: [Rule] = [
        #Rule(Self.$isActive) { $0 == true }
    ]
    }
