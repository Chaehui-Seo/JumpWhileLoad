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
        _ builder: JumpWhileLoad.Builder = .init(),
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

        topVC.present(builder.build(), animated: animated)
    }

    @MainActor public static func fullScreenView(
        _ builder: JumpWhileLoad.Builder = .init()
    ) -> some View {
        JumpWhileLoadView(builder)
            .ignoresSafeArea()
    }
}
