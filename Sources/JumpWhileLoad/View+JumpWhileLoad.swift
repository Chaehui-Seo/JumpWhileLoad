//
//  View+JumpWhileLoad.swift
//  JumpWhileLoad
//
//  Created by 서채희 on 4/6/25.
//

import SwiftUI

extension View {
    func jumpWhileLoad(
        isPresented: Binding<Bool>,
        character: UIImage? = nil,
        jumpCharacter: UIImage? = nil,
        normalObstacles: [UIImage] = [],
        wideObstacles: [UIImage] = []
    ) -> some View {
        self.modifier(
            JumpWhileLoadModifier(
                isPresented: isPresented,
                character: character,
                jumpCharacter: jumpCharacter,
                normalObstacles: normalObstacles,
                wideObstacles: wideObstacles
            )
        )
    }
}
