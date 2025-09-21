//
//  QAEntryDetail.swift
//  ReaderAssistant
//
//  Created by Shravya Chepa on 9/21/25.
//

import SwiftUI

struct QAEntryDetail: View {
    let entry: QAEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            
            Text("Q: \(entry.question)")
                .font(.title3)
                .fontWeight(.bold)
            Text("A: \(entry.answer)")
                .font(.body)
            Text("Category: \(entry.category.capitalized)")
                .font(.footnote)
                .foregroundColor(.gray)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode( .inline ) // back arrow auto shown
    }
}
