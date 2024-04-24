import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let firebaseManager = FirebaseManager.shared
     
    var pieces = [PieceResponse]()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Tap me", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(addPiece), for: .touchUpInside)
        return button
    }()
    
    lazy var textField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "insert new piece"
        textfield.borderStyle = .roundedRect
        textfield.delegate = self
        return textfield
    }()
        
    @objc func addPiece() {
        firebaseManager.createPiece {
            self.firebaseManager.getPieces { pieces in
                print(pieces)
                self.pieces = pieces
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firebaseManager.getPieces { pieces in
            print(pieces)
            self.pieces = pieces
        }
        
        view.backgroundColor = .white
        view.addSubview(textField)
        view.addSubview(button)
        
        textField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(100)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(textField.snp.bottom).offset(16)
            make.width.equalTo(120)
            make.height.equalTo(44)
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if var piece = pieces.first {
            piece.role = textField.text ?? ""
            firebaseManager.updatePiece(piece)
        }
        textField.resignFirstResponder()
        return true
    }
}
