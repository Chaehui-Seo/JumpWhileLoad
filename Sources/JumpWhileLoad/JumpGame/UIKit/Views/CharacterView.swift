import UIKit

class CharacterView: UIView {
    enum Metric {
        static let width = 50
        static let height = 50
    }
    
    private var characterImage = UIImage(named: "character", in: .module, compatibleWith: nil)
    private var jumpCharacterImage = UIImage(named: "character_jump", in: .module, compatibleWith: nil)
    
    init(characterImage: UIImage?, jumpCharacterImage: UIImage?) {
        super.init(frame: .zero)
        if let characterImage = characterImage {
            self.characterImage = characterImage
        }
        if let jumpCharacterImage = jumpCharacterImage {
            self.jumpCharacterImage = jumpCharacterImage
        }
        let imageview = UIImageView(image: self.characterImage)
        imageview.contentMode = .scaleAspectFill
        imageview.sizeToFit()
        imageview.frame = .init(x: 0, y: 0, width: Metric.width, height: Metric.height)
        self.addSubview(imageview)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isJumping = false {
        didSet {
            self.subviews.forEach { $0.removeFromSuperview() }
            let imageview = isJumping
                            ? UIImageView(image: jumpCharacterImage)
                            : UIImageView(image: characterImage)
            imageview.contentMode = .scaleAspectFill
            imageview.sizeToFit()
            imageview.frame = .init(x: 0, y: 0, width: Metric.width, height: Metric.height)
            self.addSubview(imageview)
        }
    }
}
