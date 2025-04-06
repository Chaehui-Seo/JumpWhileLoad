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
    private let normalObstacles: [UIImage]
    private let wideObstacles: [UIImage]

    public init(
        character: UIImage? = nil,
        jumpCharacter: UIImage? = nil,
        normalObstacles: [UIImage] = [],
        wideObstacles: [UIImage] = []
    ) {
        self.character = character
        self.jumpCharacter = jumpCharacter
        self.normalObstacles = normalObstacles
        self.wideObstacles = wideObstacles
    }

    public func makeUIViewController(context: Context) -> UIViewController {
        return JumpWhileLoad
            .builder()
            .withCharacter(character ?? UIImage())
            .withJumpCharacter(jumpCharacter ?? UIImage())
            .withNormalObstacles(normalObstacles)
            .withWideObstacles(wideObstacles)
            .build()
    }

    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}

