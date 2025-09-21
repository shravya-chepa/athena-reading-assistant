import Foundation
import FirebaseFirestore

class FirebaseService {
    private let db = Firestore.firestore()
    
    func save(entry: QAEntry) {
        do {
            let data = try JSONEncoder().encode(entry)
            if let dict = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                db.collection("qaEntries").document(entry.id.uuidString).setData(dict) { error in
                    if let error = error {
                        print("Firebase save error: \(error.localizedDescription)")
                    } else {
                        print("Saved entry \(entry.id) to Firebase")
                    }
                }
            }
        } catch {
            print("Encoding error: \(error.localizedDescription)")
        }
    }
    
    func fetch(completion: @escaping ([QAEntry]) -> Void) {
        db.collection("qaEntries").order(by: "timestamp", descending: true).getDocuments { snapshot, error in
            if let error = error {
                print("Fetch error: \(error.localizedDescription)")
                completion([])
                return
            }
            
            let entries: [QAEntry] = snapshot?.documents.compactMap { doc in
                do {
                    let data = try JSONSerialization.data(withJSONObject: doc.data())
                    return try JSONDecoder().decode(QAEntry.self, from: data)
                } catch {
                    print("Decode error: \(error)")
                    return nil
                }
            } ?? []
            
            completion(entries)
        }
    }
}
