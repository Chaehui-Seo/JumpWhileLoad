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
    
    nonisolated(unsafe) var displayLink: CADisplayLink?
    var lastTimestamp: CFTimeInterval = -1
    var jumpAnimation = UIViewPropertyAnimator(duration: 0, curve: .linear, animations: nil)
    
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
        displayLink?.invalidate()
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black.withAlphaComponent(0.5)
        
        NotificationCenter.default.addObserver(self, selector: #selector(finishLoading), name: JumpWhileLoad.finishLoadingNotification, object: nil)
        // Reset the timestamp reference when the app returns from the background.
        // (CADisplayLink pauses automatically in the background; this prevents a stale timestamp on resume.)
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)

        // Set up game background
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
        
        // Set up character
        characterView.frame = .init(x: Metric.CharacterView.initialX,
                                    y: Metric.CharacterView.initialY,
                                    width: Metric.CharacterView.width,
                                    height: Metric.CharacterView.height)
        characterView.layer.cornerRadius = 2
        gameView.addSubview(characterView)
        
        // Set up retry overlay (initially hidden)
        retryView.isHidden = true
        gameView.addSubview(retryView)
        NSLayoutConstraint.activate([
            retryView.leadingAnchor.constraint(equalTo: gameView.leadingAnchor),
            retryView.centerXAnchor.constraint(equalTo: gameView.centerXAnchor),
            retryView.topAnchor.constraint(equalTo: statusBar.bottomAnchor),
            retryView.bottomAnchor.constraint(equalTo: gameView.bottomAnchor),
        ])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        displayLink?.invalidate()
        displayLink = nil
        if jumpAnimation.state == .active {
            jumpAnimation.stopAnimation(true)
        }
    }

    func jump() {
        if jumpState == .tapDisabled || jumpState == .doubleTapDisabled {
            return
        }

        // Double-jump during descent: commit the current visual position to the model frame to prevent snapping
        if jumpAnimation.state == .active {
            jumpAnimation.stopAnimation(true)
            jumpAnimation.finishAnimation(at: .current)
        }

        let targetY: CGFloat = jumpState == .doubleTapEnabled
                                ? Metric.CharacterView.singleJumpY
                                : Metric.CharacterView.doubleJumpY
        jumpState = jumpState == .doubleTapEnabled
                    ? .doubleTapDisabled
                    : .doubleTapEnabled

        jumpAnimation = UIViewPropertyAnimator(duration: 0.4, curve: .easeOut) { [weak self] in
            guard let self else { return }
            self.characterView.frame = .init(origin: .init(x: self.characterView.frame.origin.x,
                                                           y: targetY),
                                             size: self.characterView.frame.size)
        }
        characterView.isJumping = true
        jumpAnimation.addCompletion { [weak self] position in
            guard let self else { return }
            switch position {
            case .start, .current:
                break
            case .end:
                self.characterView.isJumping = false
                let duration: CGFloat = self.jumpState == .doubleTapDisabled ? 0.65 : 0.55
                self.jumpState = self.jumpState == .doubleTapDisabled ? .tapDisabled : .doubleTapEnabled
                self.jumpAnimation = UIViewPropertyAnimator(duration: duration, curve: .easeIn) { [weak self] in
                    guard let self else { return }
                    self.characterView.frame = .init(origin: .init(x: self.characterView.frame.origin.x,
                                                                   y: Metric.CharacterView.initialY),
                                                     size: self.characterView.frame.size)
                }
                self.characterView.isJumping = true
                self.jumpAnimation.addCompletion { [weak self] position in
                    guard let self else { return }
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
                self.jumpAnimation.startAnimation()
            @unknown default:
                fatalError()
            }
        }
        jumpAnimation.startAnimation()
    }
    
    func resetMapBackground() {
        point = 0
        let mapView1 = MapView()
        let mapView2 = MapView()
        mapView1.frame = .init(x: 0,
                               y: Metric.MapView.initialY,
                               width: self.mapContainerView.frame.width,
                               height: Metric.MapView.height)
        mapView2.frame = .init(x: self.mapContainerView.frame.width,
                               y: Metric.MapView.initialY,
                               width: self.mapContainerView.frame.width,
                               height: Metric.MapView.height)
        mapContainerView.addSubview(mapView1)
        mapContainerView.addSubview(mapView2)
        mapView2.setObstacles(normalObstacles: self.normalObstacles,
                              wideObstacles: self.wideObstacles)
        currentMapViews = [mapView1, mapView2]
    }
    
    func startGameLoop() {
        displayLink?.invalidate()
        lastTimestamp = -1
        displayLink = CADisplayLink(target: self, selector: #selector(gameLoopTick(_:)))
        displayLink?.add(to: .main, forMode: .common)
    }

    @objc func gameLoopTick(_ link: CADisplayLink) {
        // On the first frame, record the timestamp as the baseline for deltaTime calculation
        guard lastTimestamp >= 0 else {
            lastTimestamp = link.timestamp
            return
        }
        // Cap deltaTime to prevent a large position jump after returning from background (max 50ms)
        let deltaTime = min(link.timestamp - lastTimestamp, 0.05)
        lastTimestamp = link.timestamp

        let moveDistance = Metric.Game.scrollSpeed * deltaTime

        // Scroll the map
        currentMapViews.forEach { $0.frame.origin.x -= moveDistance }

        // Point scoring: check whether an obstacle has fully passed the character
        currentMapViews.forEach { mapView in
            mapView.obstacles.forEach { obstacle in
                if obstacle.tag == 1 { return }
                let globalMaxX = mapView.convert(CGPoint(x: obstacle.frame.maxX, y: 0), to: gameView).x
                if globalMaxX < Metric.CharacterView.initialX {
                    point += 1
                    obstacle.tag = 1
                }
            }
        }

        // Collision detection (only check the leading map)
        if let firstMapView = currentMapViews.first {
            for obstacle in firstMapView.obstacles {
                if obstacle.check(targetView: characterView, rootView: gameView) {
                    displayLink?.invalidate()
                    displayLink = nil
                    if jumpAnimation.state == .active {
                        jumpAnimation.stopAnimation(true)
                    }
                    buttonState = .retry
                    return
                }
            }
        }

        // Map cycling: recycle the map when the trailing edge of the last map enters the container
        if let lastMapView = currentMapViews.last, lastMapView.frame.maxX <= mapContainerView.frame.width {
            currentMapViews.first?.removeFromSuperview()
            let newMapView = MapView()
            newMapView.frame = .init(x: mapContainerView.frame.width,
                                     y: Metric.MapView.initialY,
                                     width: mapContainerView.frame.width,
                                     height: Metric.MapView.height)
            newMapView.setObstacles(normalObstacles: normalObstacles, wideObstacles: wideObstacles)
            mapContainerView.addSubview(newMapView)
            currentMapViews = [lastMapView, newMapView]
        }
    }
}

extension JumpGameViewController: JumpGameControllable {
    @objc func finishLoading() {
        self.loadingFinished = true
    }

    @objc func handleAppDidBecomeActive() {
        // Reset so that time accumulated while in the background is not applied all at once on the first frame
        lastTimestamp = -1
    }
}
