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
    
    // 바닥 흙 표현
    // 랜덤 생성보다는 불규칙한 뷰를 직접 추가
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
    
    func setObstacles() {
        var remainedWidth = self.frame.width // 장애물을 설치할 수 있는 너비
        var currentMinleading = Metric.minLeading // 현재의 최소 leading 위치
        while remainedWidth >= CGFloat(Metric.normalObstacles) {
            let obstacleWidth = Int(remainedWidth) < Metric.wideObstacles
                                ? Metric.normalObstacles
                                : [Metric.normalObstacles, Metric.wideObstacles].randomElement() ?? 0
            let obstacle = ObstacleView()
            let leadingPosition = Int.random(in: currentMinleading ... (Int(self.frame.width) - (obstacleWidth))) // 최소 leading ~ 최대 leading  중 위치시킬 leading 선정
            obstacle.config(type: obstacleWidth == Metric.normalObstacles
                                    ? .normal
                                    : .wide,
                            leading: leadingPosition)
            currentMinleading = leadingPosition + obstacleWidth + Metric.minLeading
            remainedWidth = remainedWidth - CGFloat((currentMinleading))
            self.addSubview(obstacle)
            obstacles.append(obstacle)
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
