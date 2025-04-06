//
//  JumpWhileLoadView.swift
//  JumpWhileLoad
//
//  Created by 서채희 on 4/6/25.
//

import SwiftUI

public struct JumpWhileLoadView: UIViewControllerRepresentable {
    private let character: UIImage?
    private let jumpCharacter: UIImage?
    private let normalObstacles: [UIImage]?
    private let wideObstacles: [UIImage]?

    public init(
        character: UIImage? = nil,
        jumpCharacter: UIImage? = nil,
        normalObstacles: [UIImage]? = nil,
        wideObstacles: [UIImage]? = nil
    ) {
        self.character = character
        self.jumpCharacter = jumpCharacter
        self.normalObstacles = normalObstacles
        self.wideObstacles = wideObstacles
    }

    public func makeUIViewController(context: Context) -> UIViewController {
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
        let viewController = builder.build()
        viewController.modalPresentationStyle = .overCurrentContext
        return viewController
    }

    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}

