//
//  NLPService.swift
//  ReaderAssistant
//
//  Created by Shravya Chepa on 9/20/25.
//

import Foundation

// represents what kind of query the user has made
enum QueryType {
    case dictionary(word: String)
    case llm(prompt: String)
    case unknown
}

// result returned by NLPService
struct NLPResult {
    let originalQuery: String
    let answer: String
    let source: QueryType
}

class NLPService {
    private let dictionaryService = DictionaryService()
    // private let llmService = LLMService()
    
    func process(query: String, completion: @escaping (NLPResult?) -> Void ) {
        let type = classifyQuery(query: query)
        
        switch type {
        case .dictionary(let word):
            dictionaryService.lookup(word: word) { definition in
                guard let definition = definition else {
                    completion(nil)
                    return
                }
                completion(NLPResult(originalQuery: query, answer: definition, source: type))
            }
        case .llm(let prompt):
            print("llm service here")
        case .unknown:
        completion(NLPResult(originalQuery: query, answer: "I'm not sure what you mean.", source: .unknown))
        }
    }
    
    private func classifyQuery(query: String) -> QueryType {
        let lowerQuery = query.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        if lowerQuery.hasPrefix("what does") && lowerQuery.contains("mean") {
            if let startRange = lowerQuery.range(of: "what does "),
               let endRange = lowerQuery.range(of: " mean") {
                
                let wordRange = startRange.upperBound..<endRange.lowerBound
                let wordPart = String(lowerQuery[wordRange])
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .replacingOccurrences(of: "the word", with: "")
                
                if !wordPart.isEmpty {
                    print("DEBUG NLPService: Word for dictionary = \(wordPart)")
                    return .dictionary(word: wordPart)
                }
            }
        }
        
        // everything else -> llm
        return .llm(prompt: query)
    }
}
