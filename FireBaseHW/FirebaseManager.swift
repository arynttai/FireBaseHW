import Foundation
import FirebaseCore
import FirebaseFirestore

class FirebaseManager {
    
    static let shared = FirebaseManager()
    
    var db: Firestore!
    
    func createPiece(completion: @escaping () -> Void) {
        db = Firestore.firestore()
        do {
            let ref = try db.collection("pieces").addDocument(data: [
                "name": "King",
                "role": "Senior player"
            ])
            print("Document added with ID: \(ref.documentID)")
            completion()
        } catch {
            print("Error adding document: \(error)")
        }
    }
    
    func getPieces(completion: @escaping ([PieceResponse]) -> Void) {
        db = Firestore.firestore()
        
        db.collection("pieces").getDocuments { snapshot, error in
            if let error = error  {
                print(error)
            }
            guard let documents = snapshot?.documents else {
                print("Error while getting documents")
                return
            }
            var pieces = [PieceResponse]()
            for document in documents {
                if let piece = try? document.data(as: Piece.self) {
                    let response = PieceResponse(piece: piece, id: document.documentID)
                    pieces.append(response)
                }
            }
            completion(pieces)
        }
    }
    
    func updatePiece(_ newPiece: PieceResponse) {
        db = Firestore.firestore()
        db.collection("pieces").document(newPiece.id).setData(["role": newPiece.role], merge: true)
    }
    
    func deleteUser(_ newPiece: PieceResponse) {
        db = Firestore.firestore()
        db.collection("pieces").document(newPiece.id).delete()
    }
}
