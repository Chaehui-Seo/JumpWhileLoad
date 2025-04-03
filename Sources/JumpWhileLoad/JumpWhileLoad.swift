import UIKit

public class JumpWhileLoad {
    static let finishLoadingNotification = Notification.Name("JumpWhileLoad.FinishLoading")
    
    public static func finishLoading() {
        NotificationCenter.default.post(name: finishLoadingNotification, object: nil)
    }
    
    public static func builder() -> Builder {
        return Builder()
    }
    
    public class Builder {
        public init() {}
        
        private var character: UIImage? = nil
        private var jumpCharacter: UIImage? = nil
        private var normalObstacles: [UIImage] = []
        private var wideObstacles: [UIImage] = []
        
        public func withCharacter(_ image : UIImage) -> Builder {
            self.character  = image
            return self
        }
        
        public func withJumpCharacter(_ image : UIImage) -> Builder {
            self.jumpCharacter = image
            return self
        }
        
        public func withNormalObstacles(_ images : [UIImage]) -> Builder {
            self.normalObstacles = images
            return self
        }
        
        public func withWideObstacles(_ images : [UIImage]) -> Builder {
            self.wideObstacles = images
            return self
        }
        
        @MainActor
        public func build() -> (UIViewController & JumpGameControllable) {
            let vc = JumpGameViewController()
            vc.character = character
            vc.jumpCharacter = jumpCharacter
            vc.normalObstacles = normalObstacles
            vc.wideObstacles = wideObstacles
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            return vc
        }
    }
}
