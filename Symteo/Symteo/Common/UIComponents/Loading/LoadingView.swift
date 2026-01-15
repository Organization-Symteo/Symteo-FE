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
    }

    // MARK: - Properties
    private let image: Image = Image("loading1")
    let title: String
    private let subtitle: String = "잠시만 기다려주세요"
    let progress: Double?

    // MARK: - Init
    init(
        title: String = "처리 중입니다",
        progress: Double? = nil
    ) {
        self.title = title
        self.progress = progress
    }

    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {

            Spacer()

            image
                .resizable()
                .scaledToFit()
                .frame(width: 170, height: 129)
                .padding(.bottom, 39)

            Group {
                if let progress {
                    ProgressView(value: progress)
                } else {
                    ProgressView()
                }
            }
            .progressViewStyle(LinearProgressViewStyle())
            .frame(width: 300, height: 6)
            .padding(.bottom, 28)

            VStack(spacing: 6) {
                Text(title)
                    .font(.PretendardRegular(size: 16))
                    .foregroundColor(.gray900)

                Text(subtitle)
                    .font(.PretendardRegular(size: 16))
                    .foregroundColor(.gray900)
            }

            Spacer()
        }
        .padding()
        .background(Color(.systemBackground).ignoresSafeArea())
        .safeAreaInset(edge: .bottom) {
            Color.clear
                .frame(height: Layout.bottomInsetHeight)
        }
    }
}

#Preview {
    LoadingView()
}
