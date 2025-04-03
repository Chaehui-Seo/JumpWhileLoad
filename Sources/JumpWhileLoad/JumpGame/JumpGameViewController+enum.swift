import UIKit

// MARK: - Define enum types to use
extension JumpGameViewController {
    // Metric values for UI
    enum Metric {
        enum GameView {
            static let leading: CGFloat = 20
            static let height: CGFloat = 400
        }
        
        enum StatusBar {
            static let height: CGFloat = 50
        }
        
        enum ActionButton {
            static let height: CGFloat = 40
            static let width: CGFloat = 170
        }
        
        enum CharacterView {
            static let initialX: CGFloat = 50
            static let initialY: CGFloat = 250
            static let singleJumpY: CGFloat = 60
            static let doubleJumpY: CGFloat = 120
            static let height: CGFloat = 50
            static let width: CGFloat = 50
        }
        
        enum MapView {
            static let initialY: CGFloat = 50
            static let height: CGFloat = 280
        }
        
        enum LoadingView {
            static let progressWidth: CGFloat = 12
            static let progressHeight: CGFloat = 12
            static let endButtonWidth: CGFloat = 24
            static let endButtonHeight: CGFloat = 24
        }
    }
    
    // Button action states
    enum ButtonState: String {
        case start = "START"
        case jump = "JUMP"
        case retry = "RETRY"
    }
    
    // Character jump states
    enum JumpState {
        case tapEnabled
        case tapDisabled
        case doubleTapEnabled
        case doubleTapDisabled
    }
}
