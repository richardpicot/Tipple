//
//  WeekDetailView.swift
//  Tipple
//
//  Created by Richard Picot on 03/09/2023.
//

import SwiftUI

struct WeekDetailView: View {
    var drinks: [Drink]
    var formatDate: (Date) -> String
    
    var body: some View {
        List {
            ForEach(drinks, id: \.id) { drink in
                HStack {
                    Text(formatDate(drink.dateAdded))
                    Spacer()
                    Text("\(drink.amount)")
                        .foregroundColor(.gray)
                }
            }
        }
        .navigationBarTitle("Details", displayMode: .inline)
    }
}

//#Preview {
//    WeekDetailView()
//}
