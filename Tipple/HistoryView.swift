//
//  HistoryView.swift
//  Tipple
//
//  Created by Richard Picot on 25/06/2023.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Query(sort: \Drink.dateAdded, order: .reverse, animation: .default)
    var drinks: [Drink]
    
    var body: some View {
        NavigationView {
            List(drinks) { drink in
                Text(drink.dateAdded.formatted(date: .long, time: .shortened))
                    .swipeActions {
                        Button("Delete", role: .destructive) {
                            modelContext.delete(drink)
                        }
                    }
            }
            .navigationBarTitle("History", displayMode: .inline)
            .toolbar {
                Button(action: {
                    dismiss()
                }) {
                    Text("Done").bold()
                }
            }
        }
        .fontDesign(.rounded)
    }
}


#Preview {
    HistoryView()
}
