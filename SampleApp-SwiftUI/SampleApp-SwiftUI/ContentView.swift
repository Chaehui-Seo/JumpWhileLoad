//
//  ContentView.swift
//  SampleApp-SwiftUI
//
//  Created by 서채희 on 4/6/25.
//

import SwiftUI
import JumpWhileLoad

struct ContentView: View {
    var body: some View {
        ZStack{
            VStack {
                Button("START") {
                    JumpWhileLoadSwiftUI.present()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        JumpWhileLoadSwiftUI.finishLoading()
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
