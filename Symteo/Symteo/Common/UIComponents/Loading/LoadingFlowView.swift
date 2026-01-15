//
//  LoadingFlowView.swift
//  Symteo
//
//  Created by 박정환 on 1/13/26.
//

import SwiftUI

import Combine

struct LoadingFlowView: View {
    let title: String
    @State private var progress: Double = 0.0
    @State private var isDone: Bool = false

    init(title: String = "처리 중입니다") {
        self.title = title
    }

    private let timer = Timer
        .publish(every: 0.03, on: .main, in: .common)
        .autoconnect()

    var body: some View {
        NavigationStack {
            ZStack {
                NavigationLink(isActive: $isDone) {
                    LoadingCompleteView()
                        .navigationBarBackButtonHidden(true)
                        .toolbar(.hidden, for: .navigationBar)
                } label: {
                    EmptyView()
                }

                LoadingView(
                    title: title,
                    progress: progress
                )
            }
            .onReceive(timer) { _ in
                if progress < 0.9 {
                    progress += 0.003
                }
            }
            .task {
                // 실제 로딩 작업
                try? await Task.sleep(nanoseconds: 2_000_000_000)

                withAnimation(.easeOut(duration: 0.25)) {
                    progress = 1.0
                }

                try? await Task.sleep(nanoseconds: 250_000_000)
                isDone = true
            }
        }
    }
}

#Preview() {
    LoadingFlowView()
}
