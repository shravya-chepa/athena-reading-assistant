//
//  QAEntry.swift
//  ReaderAssistant
//
//  Created by Shravya Chepa on 9/21/25.
//

import Foundation

struct QAEntry: Codable, Identifiable, @unchecked Sendable {
    let id: UUID
    let question: String
    let answer: String
    let category: String
    let timestamp: Date
    
    // default initializer for new entries
    init(question: String, answer: String, category: String) {
        self.id = UUID()
        self.question = question
        self.answer = answer
        self.category = category
        self.timestamp = Date()
    }
    
    // full initializer for restoring from Firebase
    init(id: UUID, question: String, answer: String, category: String, timestamp: Date) {
        self.id = id
        self.question = question
        self.answer = answer
        self.category = category
        self.timestamp = timestamp
    }
}
