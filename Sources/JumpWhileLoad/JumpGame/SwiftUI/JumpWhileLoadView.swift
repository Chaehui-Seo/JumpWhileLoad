//
//  JumpWhileLoadView.swift
//  JumpWhileLoad
//
//  Created by 서채희 on 4/6/25.
//

import SwiftUI

public struct JumpWhileLoadView: UIViewControllerRepresentable {
    private let builder: JumpWhileLoad.Builder

    public init(_ builder: JumpWhileLoad.Builder = .init()) {
        self.builder = builder
    }

    public func makeUIViewController(context: Context) -> UIViewController {
        let viewController = builder.build()
        viewController.modalPresentationStyle = .overCurrentContext
        return viewController
    }

    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}
