//
//  HistoryView.swift
//  ReaderAssistant
//
//  Created by Shravya Chepa on 9/21/25.
//
import SwiftUI

struct HistoryView: View {
    @ObservedObject var storageVM: QAStorageViewModel

    @State private var showWords = true
    @State private var showGeneral = true
    @State private var showMisc = true

    var body: some View {
        NavigationStack {

            List {
                Section(header: Text("Words")) {
                    DisclosureGroup(isExpanded: $showWords) {
                        ForEach(
                            storageVM.entries.filter { $0.category == "word" }
                        ) { entry in
                            NavigationLink(
                                destination: QAEntryDetail(entry: entry)
                            ) {
                                VStack(alignment: .leading) {
                                    Text(entry.question)
                                        .font(.headline)
                                    Text(entry.answer)
                                        .font(.subheadline)
                                        .lineLimit(1)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    storageVM.delete(entry: entry)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    } label: {
                        Text("Words")
                            .font(.headline)
                    }
                }

                Section(header: Text("General")) {
                    DisclosureGroup(isExpanded: $showGeneral) {
                        ForEach(
                            storageVM.entries.filter {
                                $0.category == "general"
                            }
                        ) { entry in
                            NavigationLink(
                                destination: QAEntryDetail(entry: entry)
                            ) {
                                VStack(alignment: .leading) {
                                    Text(entry.question)
                                        .font(.headline)
                                    Text(entry.answer)
                                        .font(.subheadline)
                                        .lineLimit(1)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    storageVM.delete(entry: entry)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    } label: {
                        Text("General")
                            .font(.headline)
                    }
                }

                Section(header: Text("Miscellaneous")) {
                    DisclosureGroup(isExpanded: $showMisc) {
                        ForEach(
                            storageVM.entries.filter { $0.category == "misc" }
                        ) { entry in
                            NavigationLink(
                                destination: QAEntryDetail(entry: entry)
                            ) {
                                VStack(alignment: .leading) {
                                    Text(entry.question)
                                        .font(.headline)
                                    Text(entry.answer)
                                        .font(.subheadline)
                                        .lineLimit(1)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    storageVM.delete(entry: entry)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    } label: {
                        Text("Miscellaneous")
                            .font(.headline)
                    }
                }
            }
            .navigationBarTitle("History")
        }
    }
}
