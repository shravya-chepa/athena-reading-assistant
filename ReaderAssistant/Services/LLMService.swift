//
//  LLMService.swift
//  ReaderAssistant
//
//  Created by Shravya Chepa on 9/20/25.
//

import Foundation

class LLMService {
    private let session = URLSession.shared
    private let apiKey: String
    
    init?() {
        // pull key from Info.plist (injected via Config.xcconfig)
        guard let key = Bundle.main.object(forInfoDictionaryKey: "GROQ_API_KEY") as? String else {
            print("ERROR: GROQ_API_KEY not found in Info.plist")
            return nil
        }
        self.apiKey = key
    }
    
    func send(prompt: String, completion: @escaping (String?) -> Void) {
        
        guard let url = URL(string: "https://api.groq.com/openai/v1/chat/completions") else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // use groq model
        let body: [String: Any] = [
            "model": "llama-3.1-8b-instant",
            "messages": [
                ["role": "system", "content": "You are a helpful voice assistant helping with reading books and literature. Keep your responses concise - to four sentences unless absolutely necessary. If the prompt is not literature-related, give a graceful response saying you can't assist with that."],
                ["role": "user", "content": prompt]
            ]
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        session.dataTask(with: request) { data, response, error  in
            if let error = error {
                print("LLMService error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                // basic decode of the response
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                print("DEBUG LLMService raw JSON: \(json ?? [:])")
                
                if let choices = json?["choices"] as? [[String: Any]],
                   let first = choices.first,
                   let message = first["message"] as? [String:Any],
                   let content = message["content"] as? String {
                    completion(content.trimmingCharacters(in: .whitespacesAndNewlines))
                    
                    print("DEBUG LLMService parsed answer: \(content)")
                } else {
                    print("LMSService: Unexpected response format")
                }
            } catch {
                print("LMSService: Service decode error: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
}
