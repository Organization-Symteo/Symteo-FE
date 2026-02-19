//
//  ReportLoadingFlowScreen.swift
//  Symteo
//
//  Created by 박정환 on 2/19/26.
//

import SwiftUI
import Combine

struct ReportLoadingFlowScreen: View {
    private enum Animation {
        static let tickInterval: TimeInterval = 0.03
        static let fakeStep: Double = 0.003
        static let fakeCap: Double = 0.9

        static let finalFillDuration: Double = 0.18
        static let finalFillWait: UInt64 = 200_000_000
    }

    let container: DIContainer
    let kind: SurveyKind
    let reportId: Int?

    let onTapHome: () -> Void
    let onTapReport: (Int) -> Void

    @State private var progress: Double = 0.0
    @State private var isCompleted: Bool = false
    @State private var didFinishWork: Bool = false

    private let timer = Timer
        .publish(every: Animation.tickInterval, on: .main, in: .common)
        .autoconnect()

    var body: some View {
        LoadingView(
            title: "검사 분석 중...",
            progress: progress,
            isCompleted: isCompleted,
            completedTitle: "검사 완료!",
            onTapLeft: { onTapHome() },
            onTapRight: {
                guard let reportId else { return }
                onTapReport(reportId)
            }
        )
        .onReceive(timer) { _ in
            guard !isCompleted else { return }
            guard !didFinishWork else { return }

            if progress < Animation.fakeCap {
                progress += Animation.fakeStep
            }
        }
        .onChange(of: reportId, initial: true) { _, newValue in
            // reportId가 생긴 순간을 작업 완료로 간주
            if newValue != nil {
                didFinishWork = true
            }
        }
        .onChange(of: didFinishWork) { finished in
            guard finished else { return }
            guard !isCompleted else { return }

            withAnimation(.easeOut(duration: Animation.finalFillDuration)) {
                progress = 1.0
            }

            Task {
                try? await Task.sleep(nanoseconds: Animation.finalFillWait)
                withAnimation(.easeInOut(duration: 0.2)) {
                    isCompleted = true
                }
            }
        }
    }
}
