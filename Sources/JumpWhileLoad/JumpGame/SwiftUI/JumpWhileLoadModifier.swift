//
//  JumpWhileLoadModifier.swift
//  JumpWhileLoad
//
//  Created by 서채희 on 4/6/25.
//

import SwiftUI

struct JumpWhileLoadModifier: ViewModifier {
    @Binding var isPresented: Bool

    let character: UIImage?
    let jumpCharacter: UIImage?
    let normalObstacles: [UIImage]
    let wideObstacles: [UIImage]

    func body(content: Content) -> some View {
        ZStack {
            content

            if isPresented {
                JumpWhileLoadView(
                    character: character,
                    jumpCharacter: jumpCharacter,
                    normalObstacles: normalObstacles,
                    wideObstacles: wideObstacles
                )
                .jumpSafeArea()
            }
        }
    }
}

extension View {
    @ViewBuilder
    func jumpSafeArea() -> some View {
        if #available(iOS 14.0, *) {
            self.ignoresSafeArea()
        } else {
            self.edgesIgnoringSafeArea(.all)
        }
    }
}
