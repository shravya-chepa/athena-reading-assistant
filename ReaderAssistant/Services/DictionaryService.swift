//
//  DictionaryService.swift
//  ReaderAssistant
//
//  Created by Shravya Chepa on 9/20/25.
//

import Foundation

class DictionaryService {
    
    // api models
    struct DictionaryEntry: Codable {
        let word: String
        let phonetic: String?
        let phonetics: [Phonetic]?
        let origin: String?
        let meanings: [Meaning]
    }
    
    struct Phonetic: Codable {
        let text: String?
        let audio: String?
    }
    
    struct Meaning: Codable {
        let partOfSpeech: String
        let definitions: [Definition]
    }
    
    struct Definition: Codable {
        let definition: String
        let example: String?
        let synonyms: [String]?
        let antonyms: [String]?
    }
    
    // lookup method
    // looks up a word in the dictionary and returns its first definition (nicely formatted)
    func lookup(word: String, completion: @escaping (String?) -> Void) {
        let baseUrl = "https://api.dictionaryapi.dev/api/v2/entries/en/"
        
        guard let url = URL(string: baseUrl + word.lowercased()) else {
            completion(nil)
            return
        }
        
        print("DEBUG DictionaryService: Fetching definition for word \(word)")
        
        URLSession.shared.dataTask(with: url) {data, response, error in
            
            if let error = error {
                print("DictionaryService error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode([DictionaryEntry].self, from: data)
                
                if let entry = decoded.first,
                   let firstMeaning = entry.meanings.first,
                   let firstDef = firstMeaning.definitions.first {
                    var answer = "\(entry.word): \(firstMeaning.partOfSpeech) \(firstDef.definition)"
                    
                    if let example = firstDef.example {
                        answer += " (e.g. \(example))"
                    }
                    
                    completion(answer)
                    
                } else {
                    completion("Sorry, I couldn't find that word in the dictionary. Try another one!")
                }
                
            }
            catch {
                print("Failed to decode dictionary API: \(error)")
                completion(nil)
            }
        }.resume()
    }
}
