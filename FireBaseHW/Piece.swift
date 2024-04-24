import Foundation

struct Piece: Codable{
    var name: String
    var role: String
}

struct PieceResponse{
    var name: String
    var role: String
    var id: String
    
    init(piece: Piece, id: String) {
        self.name = piece.name
        self.role = piece.role
        self.id = id
    }
}
