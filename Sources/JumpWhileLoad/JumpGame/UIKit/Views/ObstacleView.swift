import UIKit

class ObstacleView: UIView {
    enum Metric {
        static let mapViewY = 280
        static let bottomMargin = 30
        static let normalSize = 40
        static let wideSize = 70
    }
    enum Size {
        case normal
        case wide
    }
    
    func config(type: Size, leading: Int, obstacleImages: [UIImage]? = nil) {
        switch type {
        case .normal:
            self.frame = .init(x: leading,
                               y: Metric.mapViewY - Metric.bottomMargin - Metric.normalSize,
                               width: Metric.normalSize,
                               height: Metric.normalSize)
            let imageView = UIImageView()
            imageView.image = obstacleImages?.randomElement() ?? .init(named: ["obstacle_normal_1", "obstacle_normal_2"].randomElement() ?? "obstacle_normal_1", in: .module, compatibleWith: nil)
            imageView.frame = .init(x: 0, y: 0, width: Metric.normalSize, height: Metric.normalSize)
            self.addSubview(imageView)
        case .wide:
            self.frame = .init(x: leading, 
                               y: Metric.mapViewY - Metric.bottomMargin - Metric.wideSize,
                               width: Metric.wideSize,
                               height: Metric.wideSize)
            let imageView = UIImageView()
            imageView.image = obstacleImages?.randomElement() ?? .init(named: ["obstacle_wide_1", "obstacle_wide_2"].randomElement() ?? "obstacle_wide_1", in: .module, compatibleWith: nil)
            imageView.frame = .init(x: 0, y: 0, width: Metric.wideSize, height: Metric.wideSize)
            self.addSubview(imageView)
        }
    }
    
    func check(targetView: UIView, rootView: UIView) -> Bool {
        guard let superview = self.superview else { return false }
        // Obstacles are positioned via direct frame updates (CADisplayLink), so the model frame matches the on-screen position.
        // Only the character is animated via UIViewPropertyAnimator, so its presentation layer is used.
        let obstacleFrame = superview.convert(self.frame, to: rootView)
        let characterFrame = targetView.layer.presentation()?.frame ?? targetView.frame
        let intersection = obstacleFrame.intersection(characterFrame)
        return intersection.width * intersection.height > self.frame.width * self.frame.height * 0.04 // Allow up to 4% area overlap for forgiveness
    }
}
