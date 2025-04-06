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
            imageView.image = obstacleImages?.randomElement() ?? .init(named: ["obstacle_small_1", "obstacle_small_2"].randomElement() ?? "obstacle_small_1", in: .module, compatibleWith: nil)
            imageView.frame = .init(x: 0, y: 0, width: Metric.normalSize, height: Metric.normalSize)
            self.addSubview(imageView)
        case .wide:
            self.frame = .init(x: leading, 
                               y: Metric.mapViewY - Metric.bottomMargin - Metric.wideSize,
                               width: Metric.wideSize,
                               height: Metric.wideSize)
            let imageView = UIImageView()
            imageView.image = obstacleImages?.randomElement() ?? .init(named: ["obstacle_big_1", "obstacle_big_2"].randomElement() ?? "obstacle_big_1", in: .module, compatibleWith: nil)
            imageView.frame = .init(x: 0, y: 0, width: Metric.wideSize, height: Metric.wideSize)
            self.addSubview(imageView)
        }
    }
    
    func check(targetView: UIView, rootView: UIView) -> Bool {
        guard let superview = self.superview else { return false }
        let globalPosition = superview.convert(self.layer.presentation()?.frame ?? self.frame, to: rootView)
        let rect = CGRectIntersection(globalPosition, targetView.layer.presentation()?.frame ?? targetView.frame)
        return rect.width * rect.height >  (self.frame.width * self.frame.height * 0.04) // 난이도 조절을 위해서 CGRectIntersectsRect 대신 CGRectIntersection. 면적의 0.04만큼은 허용
    }
}
