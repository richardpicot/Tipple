//
//  HistoryView.swift
//  Tipple
//
//  Created by Richard Picot on 16/06/2023.
//

import SwiftUI

struct HistoryView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("Data")
                } header: {
                    Text("Drinks")
                }
            }
            
            .navigationBarTitle("History", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                                dismiss()
                            }) {
                                Text("Done").bold()
                            })
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
