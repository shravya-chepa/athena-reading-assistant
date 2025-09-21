//
//  HistoryView.swift
//  ReaderAssistant
//
//  Created by Shravya Chepa on 9/21/25.
//
import SwiftUI

struct HistoryView: View {
    @ObservedObject var storageVM: QAStorageViewModel
    
    var body: some View {
        NavigationStack {
            
            List {
                Section(header: Text("Words")) {
                    ForEach(storageVM.entries.filter { $0.category == "word"}) { entry in
                        NavigationLink(destination: QAEntryDetail(entry: entry)) {
                            VStack(alignment: .leading) {
                                Text(entry.question)
                                    .font(.headline)
                                Text(entry.answer)
                                    .font(.subheadline)
                                    .lineLimit(1)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                
                Section(header: Text("General")) {
                    ForEach(storageVM.entries.filter { $0.category == "general"}) { entry in
                        NavigationLink(destination: QAEntryDetail(entry: entry)) {
                            VStack(alignment: .leading) {
                                Text(entry.question)
                                    .font(.headline)
                                Text(entry.answer)
                                    .font(.subheadline)
                                    .lineLimit(1)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                
                Section(header: Text("Miscellaneous")) {
                    ForEach(storageVM.entries.filter { $0.category == "misc"}) { entry in
                        NavigationLink(destination: QAEntryDetail(entry: entry)) {
                            VStack(alignment: .leading) {
                                Text(entry.question)
                                    .font(.headline)
                                Text(entry.answer)
                                    .font(.subheadline)
                                    .lineLimit(1)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("History")
        }
    }
}
