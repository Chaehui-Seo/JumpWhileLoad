//
//  ContentView.swift
//  SampleApp-SwiftUI
//
//  Created by 서채희 on 4/6/25.
//

import SwiftUI
import JumpWhileLoad

struct ContentView: View {
    @State private var showCustomAlert = false

    var body: some View {
        VStack(spacing: 16) {
            Button("START") {
                JumpWhileLoadSwiftUI.present()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    JumpWhileLoadSwiftUI.finishLoading()
                }
            }
            .font(.system(size: 18, weight: .bold))
            .controlSize(.large)
            .buttonStyle(.borderedProminent)
            .tint(.blue)

            Button("CUSTOM START") {
                showCustomAlert = true
            }
            .buttonStyle(.bordered)
            .tint(.blue)
        }
        .padding()
        .alert("Apply Custom Images?", isPresented: $showCustomAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Apply") {
                JumpWhileLoadSwiftUI.present(
                    JumpWhileLoad.Builder()
                        .withCharacter(UIImage(named: "dino_1")!)
                        .withJumpCharacter(UIImage(named: "dino_2")!)
                        .withNormalObstacles([UIImage(named: "dino_3")!,
                                             UIImage(named: "dino_4")!])
                        .withWideObstacles([UIImage(named: "dino_5")!,
                                           UIImage(named: "dino_6")!])
                )
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    JumpWhileLoadSwiftUI.finishLoading()
                }
            }
        } message: {
            Text("""
            Apply the custom images included in this sample?

            • Main character: Penguin → Dinosaur
            • Background: Snow → Forest
            """)
        }
    }
}

#Preview {
    ContentView()
}
