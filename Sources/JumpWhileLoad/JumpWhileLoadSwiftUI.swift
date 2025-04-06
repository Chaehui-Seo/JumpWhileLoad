//
//  JumpWhileLoadSwiftUI.swift
//  JumpWhileLoad
//
//  Created by 서채희 on 4/6/25.
//

import SwiftUI

public enum JumpWhileLoadSwiftUI {
    public static func finishLoading() {
        JumpWhileLoad.finishLoading()
    }
    
    @MainActor public static func present(
            character: UIImage? = nil,
            jumpCharacter: UIImage? = nil,
            normalObstacles: [UIImage]? = nil,
            wideObstacles: [UIImage]? = nil,
            animated: Bool = true
    ) {
        guard let topVC = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive })?
            .windows
            .first(where: { $0.isKeyWindow })?
            .rootViewController else {
            print("⚠️ JumpWhileLoadSwiftUI: Failed to get top view controller")
            return
        }
        
        var builder = JumpWhileLoad.builder()
        
        if let character {
            builder = builder.withCharacter(character)
        }
        
        if let jumpCharacter {
            builder = builder.withJumpCharacter(jumpCharacter)
        }
        
        if let normalObstacles {
            builder = builder.withNormalObstacles(normalObstacles)
        }
        
        if let wideObstacles {
            builder = builder.withWideObstacles(wideObstacles)
        }

        topVC.present(builder.build(), animated: animated)
    }
    
    @MainActor public static func fullScreenView(
        character: UIImage? = nil,
        jumpCharacter: UIImage? = nil,
        normalObstacles: [UIImage]? = nil,
        wideObstacles: [UIImage]? = nil
    ) -> some View {
        JumpWhileLoadView(
            character: character,
            jumpCharacter: jumpCharacter,
            normalObstacles: normalObstacles,
            wideObstacles: wideObstacles
        )
        .ignoresSafeArea()
    }
}
