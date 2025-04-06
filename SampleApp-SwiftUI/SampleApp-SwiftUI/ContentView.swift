//
//  ContentView.swift
//  SampleApp-SwiftUI
//
//  Created by 서채희 on 4/6/25.
//

import SwiftUI
import JumpWhileLoad

struct ContentView: View {
    @State private var isGamePresented = false
    
    var body: some View {
        ZStack{
            Color.red
            VStack {
                Button("Start") {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        JumpWhileLoadSwiftUI.finishLoading()
                    }
                    isGamePresented = true
                    JumpWhileLoadSwiftUI.present()
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue) // 버튼 배경색 설정
//                .fullScreenCover(isPresented: $isGamePresented) {
//                    JumpWhileLoadSwiftUI.fullScreenView()
//                }
                
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
