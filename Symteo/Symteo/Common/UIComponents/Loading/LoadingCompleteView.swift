//
//  LoadingCompleteView.swift
//  Symteo
//
//  Created by 박정환 on 1/13/26.
//

import SwiftUI

struct LoadingCompleteView: View {

    private enum Layout {
        static let bottomInsetHeight: CGFloat = 78
    }

    // MARK: - Properties
    let title: String
    let onTapLeft: () -> Void
    let onTapRight: () -> Void

    private let image: Image = Image("loading2")
    private let leftButtonTitle: String = "홈으로"
    private let rightButtonTitle: String = "리포트 보기"

    // MARK: - Init
    init(
        title: String = "검사 완료!",
        onTapLeft: @escaping () -> Void = {},
        onTapRight: @escaping () -> Void = {}
    ) {
        self.title = title
        self.onTapLeft = onTapLeft
        self.onTapRight = onTapRight
    }

    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            image
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 171)
                .padding(.bottom, 20)

            ProgressView(value: 1.0)
                .progressViewStyle(.linear)
                .frame(width: 300, height: 6)
                .tint(.maingreen)
                .padding(.bottom, 28)

            Text(title)
                .font(.PretendardRegular(size: 16))
                .foregroundColor(.gray900)

            Spacer()
        }
        .background(Color(.systemBackground).ignoresSafeArea())
        .safeAreaInset(edge: .bottom) {
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
        }
    }
}

#Preview {
    LoadingCompleteView()
}
