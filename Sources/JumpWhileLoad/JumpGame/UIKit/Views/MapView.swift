import UIKit

class MapView: UIView {
    enum Metric {
        static let normalObstacles: Int = 40
        static let wideObstacles: Int = 70
        static let minLeading: Int = 100
    }
    
    var obstacles: [ObstacleView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setMapBackground()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Ground texture decoration.
    // Irregularly-sized views are placed manually rather than generated randomly.
    func setMapBackground() {
        let view10 = GroundView(width: 10)
        let view5 = GroundView(width: 5)
        let view8 = GroundView(width: 8)
        let view3 = GroundView(width: 3)
        let view7 = GroundView(width: 7)
        self.addSubview(view10)
        self.addSubview(view5)
        self.addSubview(view8)
        self.addSubview(view3)
        self.addSubview(view7)
        NSLayoutConstraint.activate([
            view10.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
            view10.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -28),
            view5.leadingAnchor.constraint(equalTo: view10.trailingAnchor, constant: 30),
            view5.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -26),
            view8.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            view8.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -25),
            view3.trailingAnchor.constraint(equalTo: view8.leadingAnchor, constant: -20),
            view3.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -27),
            view7.leadingAnchor.constraint(equalTo: view5.trailingAnchor, constant: -15),
            view7.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24),
        ])
    }
    
    func setObstacles(normalObstacles: [UIImage] = [], wideObstacles: [UIImage] = []) {
        let mapWidth = Int(self.frame.width)
        var currentX = Metric.minLeading // Minimum x position at which the next obstacle can be placed

        while currentX + Metric.normalObstacles <= mapWidth {
            let remainingWidth = mapWidth - currentX
            let obstacleWidth = remainingWidth < Metric.wideObstacles
                                ? Metric.normalObstacles
                                : [Metric.normalObstacles, Metric.wideObstacles].randomElement()!
            let maxLeading = mapWidth - obstacleWidth
            guard currentX <= maxLeading else { break }

            let leadingPosition = Int.random(in: currentX...maxLeading)
            let obstacleType: ObstacleView.Size = obstacleWidth == Metric.normalObstacles ? .normal : .wide

            let obstacle = ObstacleView()
            obstacle.config(type: obstacleType,
                            leading: leadingPosition,
                            obstacleImages: obstacleType == .normal ? normalObstacles : wideObstacles)
            self.addSubview(obstacle)
            obstacles.append(obstacle)

            currentX = leadingPosition + obstacleWidth + Metric.minLeading
        }
    }
    
    class GroundView: UIView {
        init(width: CGFloat, height: CGFloat = 2) {
            super.init(frame: .zero)
            self.translatesAutoresizingMaskIntoConstraints = false
            self.backgroundColor = .black.withAlphaComponent(0.8)
            NSLayoutConstraint.activate([
                self.widthAnchor.constraint(equalToConstant: width),
                self.heightAnchor.constraint(equalToConstant: height)
            ])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
