import UIKit

// MARK: - Make UI views
extension JumpGameViewController {
    @objc func closeButtonDidTap() {
        self.dismiss(animated: true)
//        JumpGamePresenter.dismissIfNeeded()
    }
    
    func makeLoadingEndView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SourceCodePro-Bold", size: 18)
        label.text = "Loading Finished!"
        label.textAlignment = .center
        label.textColor = .white
        let button = UIButton()
        button.setImage(UIImage(named: "close-x-circle", in: .module, compatibleWith: nil), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closeButtonDidTap), for: .touchUpInside)
        view.addSubview(label)
        view.addSubview(button)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: 40),
            button.widthAnchor.constraint(equalToConstant: Metric.LoadingView.endButtonWidth),
            button.heightAnchor.constraint(equalToConstant: Metric.LoadingView.endButtonHeight),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
        ])
        view.isHidden = true
        return view
    }
    
    func makeLoadingInProgressView() -> UIView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 5
        let label = UILabel()
        label.font = UIFont(name: "SourceCodePro-Bold", size: 18)
        label.text = "Loading..."
        label.textColor = .black
        stackView.addArrangedSubview(loadingProgressView)
        stackView.addArrangedSubview(label)
        NSLayoutConstraint.activate([
            loadingProgressView.widthAnchor.constraint(equalToConstant: Metric.LoadingView.progressWidth),
            loadingProgressView.heightAnchor.constraint(equalToConstant: Metric.LoadingView.progressHeight),
        ])
        return stackView
    }
    
    @objc func startButtonTapped() {
        if buttonState == .start {
            buttonState = .jump
            timer?.invalidate()
            jumpState = .tapEnabled
            characterView.frame = .init(x: Metric.CharacterView.initialX,
                                        y: Metric.CharacterView.initialY,
                                        width: Metric.CharacterView.width,
                                        height: Metric.CharacterView.height)
            currentMapViews.forEach { $0.removeFromSuperview() }
            resetMapBackground()
            setTimerBackgroun()
        }
    }
    
    @objc func jumpButtonTapped() {
        switch buttonState {
        case .start:
            self.jumpButton.backgroundColor = .lightGray
        case .jump:
            jump()
        default:
            return
        }
    }
    
    @objc func retryButtonTapped() {
        buttonState = .jump
        timer?.invalidate()
        jumpState = .tapEnabled
        characterView.frame = .init(x: Metric.CharacterView.initialX,
                                    y: Metric.CharacterView.initialY,
                                    width: Metric.CharacterView.width,
                                    height: Metric.CharacterView.height)
        characterView.isJumping = false
        currentMapViews.forEach { $0.removeFromSuperview() }
        resetMapBackground()
        setTimerBackgroun()
        retryView.isHidden = true
    }
    
    func makeRetryView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.6)
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: "SourceCodePro-Bold", size: 20)
        button.setTitle("RETRY", for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = Metric.ActionButton.height / 2
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .highlighted)
        button.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: Metric.ActionButton.width),
            button.heightAnchor.constraint(equalToConstant: Metric.ActionButton.height),
        ])
        return view
    }
    
    func makeJumpButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: "SourceCodePro-Bold", size: 20)
        button.setTitle(buttonState.rawValue, for: .normal)
        button.backgroundColor = .white
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.customDarkGray.cgColor
        button.layer.cornerRadius = Metric.ActionButton.height / 2
        button.setTitleColor(UIColor.customDarkGray, for: .normal)
        button.addTarget(self, action: #selector(jumpButtonTapped), for: .touchDown)
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }
    
    func makeGameView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        view.clipsToBounds = true
        return view
    }
    
    func makeMapContainerView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        
        let groundView = UIView()
        groundView.translatesAutoresizingMaskIntoConstraints = false
        groundView.backgroundColor = .black
        view.addSubview(groundView)
        
        NSLayoutConstraint.activate([
            groundView.heightAnchor.constraint(equalToConstant: 2),
            groundView.topAnchor.constraint(equalTo: view.topAnchor, constant: 290),
            groundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            groundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        return view
    }
    
    func makeStatusBar() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = UIColor.customLightGray
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }
    
    func makePointLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SourceCodePro-Bold", size: 22)
        label.text = "0"
        return label
    }
}
