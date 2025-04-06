import UIKit

class LoadingProgressView: UIView {
    enum Metric {
        static let width = 12
        static let height = 12
    }
    private var loadingFinished = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadingAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadingAnimation() {
        CATransaction.begin()
        
        let layer : CAShapeLayer = CAShapeLayer()
        layer.strokeColor = UIColor.customDarkGray.cgColor
        layer.lineWidth = 3.0
        layer.fillColor = UIColor.clear.cgColor

        let path : UIBezierPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: Metric.width, height: Metric.height),
                                               byRoundingCorners: .allCorners,
                                               cornerRadii: CGSize(width: Metric.width, height: Metric.height))
        layer.path = path.cgPath

        let animation : CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 2.0

        CATransaction.setCompletionBlock { [weak self] in
            self?.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            if (self?.loadingFinished == true) { return }
            self?.loadingAnimation()
        }

        layer.add(animation, forKey: "strokeAnimation")
        CATransaction.commit()
        self.layer.addSublayer(layer)
    }
    
    func finishLoading() {
        loadingFinished = true
    }
}
