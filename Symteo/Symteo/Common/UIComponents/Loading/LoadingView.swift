//
//  LoadingView.swift
//  Symteo
//
//  Created by 박정환 on 1/11/26.
//

import SwiftUI

struct LoadingView: View {

    private enum Layout {
        static let bottomInsetHeight: CGFloat = 78
        static let imageBoxSize: CGFloat = 190
        static let imageToProgressSpacing: CGFloat = 24
    }

    // MARK: - Properties
    private let loadingImage: Image = Image("loading1")
    private let completedImage: Image = Image("loading2")

    let title: String
    let progress: Double?
    let isCompleted: Bool
    let completedTitle: String
    let onTapLeft: () -> Void
    let onTapRight: () -> Void

    private let subtitle: String = "잠시만 기다려주세요"
    private let leftButtonTitle: String = "홈으로"
    private let rightButtonTitle: String = "리포트 보기"

    // MARK: - Init
    init(
        title: String = "처리 중입니다",
        progress: Double? = nil,
        isCompleted: Bool = false,
        completedTitle: String = "검사 완료!",
        onTapLeft: @escaping () -> Void = { print("홈으로") },
        onTapRight: @escaping () -> Void = { print("리포트 보기") }
    ) {
        self.title = title
        self.progress = progress
        self.isCompleted = isCompleted
        self.completedTitle = completedTitle
        self.onTapLeft = onTapLeft
        self.onTapRight = onTapRight
    }

    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            ZStack {
                (isCompleted ? completedImage : loadingImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: Layout.imageBoxSize, maxHeight: Layout.imageBoxSize)
            }
            .frame(width: Layout.imageBoxSize, height: Layout.imageBoxSize)
            .padding(.bottom, Layout.imageToProgressSpacing)

            Group {
                if let progress {
                    ProgressView(value: progress)
                } else {
                    ProgressView()
                }
            }
            .progressViewStyle(LinearProgressViewStyle())
            .tint(.maingreen)
            .frame(width: 300, height: 6)
            .padding(.bottom, 28)

            VStack(spacing: 6) {
                Text(isCompleted ? completedTitle : title)
                    .font(.PretendardRegular(size: 16))
                    .foregroundColor(.gray900)
                    .lineLimit(1)

                Text(subtitle)
                    .font(.PretendardRegular(size: 16))
                    .foregroundColor(.gray900)
                    .opacity(isCompleted ? 0 : 1)
                    .accessibilityHidden(isCompleted)
            }

            Spacer()
        }
        .padding()
        .background(Color(.systemBackground).ignoresSafeArea())
        .safeAreaInset(edge: .bottom) {
            if isCompleted {
                HStack(spacing: 10) {
                    PopupCancelButton(
                        text: leftButtonTitle,
                        action: onTapLeft
                    )
                    .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56)

                    PopupConfirmButton(
                        text: rightButtonTitle,
                        action: onTapRight
                    )
                    .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 22)
                .frame(height: Layout.bottomInsetHeight)
            } else {
                Color.clear
                    .frame(height: Layout.bottomInsetHeight)
            }
        }
    }
}

#Preview {
    LoadingView(title: "검사 완료!", progress: 1.0, isCompleted: true)
}
