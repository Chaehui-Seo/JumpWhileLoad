import UIKit

class CharacterView: UIView {
    enum Metric {
        static let width = 50
        static let height = 50
    }
    
    private var characterImage = UIImage(named: "character", in: .module, compatibleWith: nil)
    private var jumpCharacterImage = UIImage(named: "character_jump", in: .module, compatibleWith: nil)
    
    private let imageView = UIImageView()

    init(characterImage: UIImage?, jumpCharacterImage: UIImage?) {
        super.init(frame: .zero)
        if let characterImage = characterImage {
            self.characterImage = characterImage
        }
        if let jumpCharacterImage = jumpCharacterImage {
            self.jumpCharacterImage = jumpCharacterImage
        }
        imageView.image = self.characterImage
        imageView.contentMode = .scaleAspectFill
        imageView.frame = .init(x: 0, y: 0, width: Metric.width, height: Metric.height)
        self.addSubview(imageView)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var isJumping = false {
        didSet {
            imageView.image = isJumping ? jumpCharacterImage : characterImage
        }
    }
}
