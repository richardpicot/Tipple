//
//  HistoryView.swift
//  Tipple
//
//  Created by Richard Picot on 16/06/2023.
//

import SwiftUI

struct HistoryView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var drinks : Drinks
    
    var body: some View {
        NavigationView {
            
            List {
                ForEach(drinks.items) { item in
                    Text(item.date.formatted(date: .long, time: .shortened))
                }
                .onDelete(perform: removeItems)
            }
            
            .navigationBarTitle("History", displayMode: .inline)
            .toolbar {
                Button {
                    let drink = DrinkItem(date: .now, amount: 1)
                    drinks.items.append(drink)
                } label: {
                    Image(systemName: "plus")
                }
            }
            
//            .navigationBarItems(trailing: Button(action: {
//                                dismiss()
//                            }) {
//                                Text("Done").bold()
//                            })
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        drinks.items.remove(atOffsets: offsets)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
