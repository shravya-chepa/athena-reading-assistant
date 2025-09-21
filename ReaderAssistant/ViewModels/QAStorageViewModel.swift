//
//  QAStorageViewModel.swift
//  ReaderAssistant
//
//  Created by Shravya Chepa on 9/21/25.
//

import Foundation
import Combine

class QAStorageViewModel: ObservableObject {
    
    @Published private(set) var entries: [QAEntry] = []
    private let storageKey = "QA_ENTRIES"
    private let firebase = FirebaseService()
    
    init() {
        load()
        syncFromFirebase()
    }
    
    func syncFromFirebase() {
            firebase.fetch { [weak self] remoteEntries in
                DispatchQueue.main.async {
                    self?.entries = remoteEntries
                    self?.save()
                }
        }
    }
    
    func addEntry(question: String, answer: String, category: String) {
        let newEntry = QAEntry(question: question, answer: answer, category: category)
        entries.append(newEntry)
        save()
        
        // push to firebase
        firebase.save(entry: newEntry)
    }
    
    func delete(entry: QAEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }
    
    private func save() {
        do {
            let data = try JSONEncoder().encode(entries)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            print("ERROR: Failed to save entries: \(error)")
        }
    }
    
    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            return
        }
        do {
            let decoded = try JSONDecoder().decode([QAEntry].self, from: data)
            self.entries = decoded
        } catch {
            print("ERROR: Failed to load entries: \(error)")
        }
    }
    
    func clear() {
        entries.removeAll()
        UserDefaults.standard.removeObject(forKey: storageKey)
    }
}
