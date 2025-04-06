import UIKit

@MainActor
public protocol JumpGameControllable: AnyObject {
    func finishLoading()
}

class JumpGameViewController: UIViewController {
    
    var character: UIImage? = nil
    var jumpCharacter: UIImage? = nil
    var normalObstacles: [UIImage] = []
    var wideObstacles: [UIImage] = []
    
    lazy var characterView = CharacterView(characterImage: character, jumpCharacterImage: jumpCharacter)
    lazy var gameView = makeGameView()
    lazy var mapContainerView = makeMapContainerView()
    lazy var statusBar = makeStatusBar()
    lazy var pointLabel = makePointLabel()
    lazy var jumpButton = makeJumpButton()
    lazy var retryView = makeRetryView()
    lazy var loadingInProgressView = makeLoadingInProgressView()
    lazy var loadingEndView = makeLoadingEndView()
    let loadingProgressView = LoadingProgressView()
    
    var timer : Timer?
    var animation = UIViewPropertyAnimator()
    
    var currentMapViews: [MapView] = []
    
    var point = 0 {
        didSet {
            pointLabel.text = "\(point)"
        }
    }
    
    var loadingFinished = false {
        didSet {
            loadingInProgressView.isHidden = loadingFinished
            loadingEndView.isHidden = !loadingFinished
            if loadingFinished {
                loadingProgressView.finishLoading()
                statusBar.backgroundColor = .customDarkGray
                
            }
        }
    }
    
    var buttonState: ButtonState = .start {
        didSet {
            jumpButton.setTitle(buttonState.rawValue, for: .normal)
            switch buttonState {
            case .start:
                jumpButton.isHidden = false
                jumpButton.backgroundColor = .white
                jumpButton.layer.borderWidth = 3
                jumpButton.layer.borderColor = UIColor.customDarkGray.cgColor
                jumpButton.setTitleColor(UIColor.customDarkGray, for: .normal)
            case .jump:
                jumpButton.isHidden = false
                jumpButton.backgroundColor = UIColor.customDarkGray
                jumpButton.layer.borderWidth = 0
                jumpButton.setTitleColor(.white, for: .normal)
                jumpButton.setTitleColor(UIColor.systemGray, for: .highlighted)
            case .retry:
                jumpButton.isHidden = true
                retryView.isHidden = false
            }
        }
    }
    
    var jumpState: JumpState = .tapEnabled
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black.withAlphaComponent(0.5)
        
        NotificationCenter.default.addObserver(self, selector: #selector(finishLoading), name: JumpWhileLoad.finishLoadingNotification, object: nil)
        
        // 게임 배경 세팅
        self.view.addSubview(gameView)
        gameView.addSubview(mapContainerView)
        gameView.addSubview(statusBar)
        gameView.addSubview(pointLabel)
        gameView.addSubview(jumpButton)
        statusBar.addSubview(loadingInProgressView)
        statusBar.addSubview(loadingEndView)
        NSLayoutConstraint.activate([
            gameView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            gameView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            gameView.heightAnchor.constraint(equalToConstant: Metric.GameView.height),
            mapContainerView.leadingAnchor.constraint(equalTo: gameView.leadingAnchor, constant: 15),
            mapContainerView.centerXAnchor.constraint(equalTo: gameView.centerXAnchor),
            mapContainerView.topAnchor.constraint(equalTo: gameView.topAnchor),
            mapContainerView.centerYAnchor.constraint(equalTo: gameView.centerYAnchor),
            statusBar.topAnchor.constraint(equalTo: gameView.topAnchor),
            statusBar.leadingAnchor.constraint(equalTo: gameView.leadingAnchor),
            statusBar.centerXAnchor.constraint(equalTo: gameView.centerXAnchor),
            statusBar.heightAnchor.constraint(equalToConstant: Metric.StatusBar.height),
            pointLabel.centerXAnchor.constraint(equalTo: gameView.centerXAnchor),
            pointLabel.topAnchor.constraint(equalTo: statusBar.bottomAnchor, constant: 70),
            jumpButton.widthAnchor.constraint(equalToConstant: Metric.ActionButton.width),
            jumpButton.heightAnchor.constraint(equalToConstant: Metric.ActionButton.height),
            jumpButton.bottomAnchor.constraint(equalTo: gameView.bottomAnchor, constant: -30),
            jumpButton.centerXAnchor.constraint(equalTo: gameView.centerXAnchor),
            loadingInProgressView.leadingAnchor.constraint(greaterThanOrEqualTo: statusBar.leadingAnchor, constant: 15),
            loadingInProgressView.centerXAnchor.constraint(equalTo: statusBar.centerXAnchor),
            loadingInProgressView.topAnchor.constraint(greaterThanOrEqualTo: statusBar.topAnchor),
            loadingInProgressView.centerYAnchor.constraint(equalTo: statusBar.centerYAnchor),
            loadingEndView.leadingAnchor.constraint(equalTo: statusBar.leadingAnchor),
            loadingEndView.trailingAnchor.constraint(equalTo: statusBar.trailingAnchor),
            loadingEndView.topAnchor.constraint(equalTo: statusBar.topAnchor),
            loadingEndView.bottomAnchor.constraint(equalTo: statusBar.bottomAnchor),
        ])
        
        // 캐릭터 세팅
        characterView.frame = .init(x: Metric.CharacterView.initialX,
                                    y: Metric.CharacterView.initialY,
                                    width: Metric.CharacterView.width,
                                    height: Metric.CharacterView.height)
        characterView.layer.cornerRadius = 2
        gameView.addSubview(characterView)
        
        // retry뷰 세팅 (처음엔 Hide 상태)
        retryView.isHidden = true
        gameView.addSubview(retryView)
        NSLayoutConstraint.activate([
            retryView.leadingAnchor.constraint(equalTo: gameView.leadingAnchor),
            retryView.centerXAnchor.constraint(equalTo: gameView.centerXAnchor),
            retryView.topAnchor.constraint(equalTo: statusBar.bottomAnchor),
            retryView.bottomAnchor.constraint(equalTo: gameView.bottomAnchor),
        ])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        JumpGamePresenter.dismissIfNeeded()
    }
    
    func jump() {
        if jumpState == .tapDisabled || jumpState == .doubleTapDisabled {
            // 점프 가능한 상태인지 확인
            return
        }
        
        let targetY: CGFloat = jumpState == .doubleTapEnabled
                                ? Metric.CharacterView.singleJumpY
                                : Metric.CharacterView.doubleJumpY
        jumpState = jumpState == .doubleTapEnabled
                    ? .doubleTapDisabled
                    : .doubleTapEnabled
        animation.stopAnimation(true)
        animation = UIViewPropertyAnimator(duration: 0.4, curve: .easeOut) {
            self.characterView.frame = .init(origin: .init(x: self.characterView.frame.origin.x,
                                                           y: targetY),
                                             size: self.characterView.frame.size)
        }
        characterView.isJumping = true
        animation.addCompletion { position in
            switch position {
            case .start, .current:
                break
            case .end:
                self.characterView.isJumping = false
                let duration: CGFloat = self.jumpState == .doubleTapDisabled ? 0.65 : 0.55
                self.jumpState = self.jumpState == .doubleTapDisabled ? .tapDisabled : .doubleTapEnabled
                self.animation = UIViewPropertyAnimator(duration: duration, curve: .easeIn) {
                    self.characterView.frame = .init(origin: .init(x: self.characterView.frame.origin.x, y: Metric.CharacterView.initialY), size: self.characterView.frame.size)
                }
                self.characterView.isJumping = true
                self.animation.addCompletion { position in
                    switch position {
                    case .start, .current:
                        break
                    case .end:
                        self.characterView.isJumping = false
                        self.jumpState = .tapEnabled
                    @unknown default:
                        fatalError()
                    }
                }
                self.animation.startAnimation()
            @unknown default:
                fatalError()
            }
        }
        animation.startAnimation()
    }
    
    func resetMapBackground() {
        point = 0
        let mapView1 = MapView()
        let mapView2 = MapView()
        mapView1.frame = .init(x: 0,
                               y: Metric.MapView.initialY,
                               width: self.mapContainerView.frame.width,
                               height: Metric.MapView.height)
        mapView2.frame = .init(x: self.mapContainerView.frame.maxX,
                               y: Metric.MapView.initialY,
                               width: self.mapContainerView.frame.width,
                               height: Metric.MapView.height)
        mapContainerView.addSubview(mapView1)
        mapContainerView.addSubview(mapView2)
        mapView2.setObstacles()
        currentMapViews = [mapView1, mapView2]
    }
    
    func setTimerBackgroun() {
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
    }
    
    //타이머 동작 func
    @objc func timerCallback() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseIn, .beginFromCurrentState, .allowAnimatedContent, .allowUserInteraction], animations: {
            self.currentMapViews.forEach {
                $0.frame = .init(x: $0.frame.origin.x - 15,
                                 y: $0.frame.origin.y,
                                 width: $0.frame.width,
                                 height: $0.frame.height)
                $0.obstacles.forEach {
                    if $0.tag == 1 { return }
                    if $0.convert($0.bounds, to: nil).maxX < Metric.CharacterView.initialX { // 장애물이 캐릭터를 완전히 지나가면 point +1
                        self.point += 1
                        $0.tag = 1
                    }
                }
            }
        }) { _ in
            if let firstMapView = self.currentMapViews.first {
                firstMapView.obstacles.forEach {
                    if $0.check(targetView: self.characterView, rootView: self.gameView) {
                        self.timer?.invalidate()
                        self.animation.stopAnimation(true)
                        self.buttonState = .retry
                    }
                }
            }
            
            if let lastMapView = self.currentMapViews.last, lastMapView.frame.maxX <= self.mapContainerView.frame.maxX {
                self.currentMapViews.first?.removeFromSuperview()
                let mapView3 = MapView()
                mapView3.frame = .init(x: self.mapContainerView.frame.maxX,
                                       y: Metric.MapView.initialY,
                                       width: self.mapContainerView.frame.width,
                                       height: Metric.MapView.height)
                mapView3.setObstacles()
                self.mapContainerView.addSubview(mapView3)
                self.currentMapViews = [lastMapView, mapView3]
            }
        }
    }
}

extension JumpGameViewController: JumpGameControllable {
    @objc func finishLoading() {
        self.loadingFinished = true
    }
}
