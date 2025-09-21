//
//  QAEntry.swift
//  ReaderAssistant
//
//  Created by Shravya Chepa on 9/21/25.
//

import Foundation

struct QAEntry: Codable, Identifiable {
    let id: UUID
    let question: String
    let answer: String
    let category: String
    let timestamp: Date
    
    init(question: String, answer: String, category: String) {
        self.id = UUID()
        self.question = question
        self.answer = answer
        self.category = category
        self.timestamp = Date()
    }
}
