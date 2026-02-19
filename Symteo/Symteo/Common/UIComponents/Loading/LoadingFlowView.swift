//
//  LoadingFlowView.swift
//  Symteo
//
//  Created by 박정환 on 1/13/26.
//

import SwiftUI
import Combine

struct LoadingFlowView: View {
    private enum Animation {
        static let tickInterval: TimeInterval = 0.03
        static let fakeStep: Double = 0.003
        static let fakeCap: Double = 0.9

        static let finalFillDuration: Double = 0.18
        static let finalFillWait: UInt64 = 200_000_000
    }

    let title: String
    let showsCompletionButtons: Bool
    let onFinish: () -> Void
    let completedTitle: String

    @State private var progress: Double = 0.0
    @State private var isCompleted: Bool = false
    @State private var didFinishWork: Bool = false

    init(
        title: String = "처리 중입니다",
        showsCompletionButtons: Bool = false,
        completedTitle: String = "검사 완료!",
        onFinish: @escaping () -> Void = {}
    ) {
        self.title = title
        self.showsCompletionButtons = showsCompletionButtons
        self.completedTitle = completedTitle
        self.onFinish = onFinish
    }

    private let timer = Timer
        .publish(every: Animation.tickInterval, on: .main, in: .common)
        .autoconnect()

    var body: some View {
        ZStack {
            LoadingView(
                title: title,
                progress: progress,
                isCompleted: isCompleted,
                completedTitle: completedTitle,
                onTapLeft: {
                    print("홈으로")
                },
                onTapRight: {
                    onFinish()
                }
            )
        }
        .onReceive(timer) { _ in
            guard !isCompleted else { return }
            guard !didFinishWork else { return }

            if progress < Animation.fakeCap {
                progress += Animation.fakeStep
            }
        }
        .task {
            // 여기에서 실제 async 작업을 수행하고, 끝나면 didFinishWork = true 로만 바꿔주세요
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            didFinishWork = true
        }
        .onChange(of: didFinishWork) { finished in
            guard finished else { return }
            guard !isCompleted else { return }

            withAnimation(.easeOut(duration: Animation.finalFillDuration)) {
                progress = 1.0
            }

            Task {
                try? await Task.sleep(nanoseconds: Animation.finalFillWait)

                if showsCompletionButtons {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isCompleted = true
                    }
                } else {
                    onFinish()
                }
            }
        }
    }
}

#Preview() {
    VStack(spacing: 40) {
        LoadingFlowView(title: "업로드 중...", showsCompletionButtons: false)

        LoadingFlowView(
            title: "검사 분석 중...",
            showsCompletionButtons: true,
            completedTitle: "검사 완료!"
        )
    }
}

