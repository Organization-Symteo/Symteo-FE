//
//  ModalView.swift
//  Symteo
//
//  Created by 박정환 on 1/9/26.
//

import SwiftUI

struct ModalView: View {
    let title: String
    let message: String?
    let confirmTitle: String
    let cancelTitle: String?
    let onConfirm: () -> Void
    let onCancel: () -> Void

    @State private var opacity: Double = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            // Dim background
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { onCancel() }

            GeometryReader { geo in
                VStack(spacing: 0) {
                    Spacer(minLength: 0)

                    VStack(spacing: 0) {
                        // Title
                        Text(title)
                            .font(.PretendardSemiBold(size: 16))
                            .foregroundColor(.gray900)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)

                        Spacer().frame(height: 10)

                        // Message (optional)
                        if let message = message {
                            Text(message)
                                .font(.PretendardRegular(size: 12))
                                .foregroundColor(.gray700)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(maxWidth: .infinity)

                            Spacer().frame(height: 24)
                        } else {
                            Spacer().frame(height: 24)
                        }

                        // Buttons
                        if let cancelTitle = cancelTitle {
                            HStack(spacing: 10) {
                                PopupCancelButton(
                                    text: cancelTitle,
                                    action: onCancel
                                )
                                .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56)

                                PopupConfirmButton(
                                    text: confirmTitle,
                                    action: onConfirm
                                )
                                .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56)
                            }
                        } else {
                            PopupConfirmButton(
                                text: confirmTitle,
                                action: onConfirm
                            )
                            .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56)
                        }
                    }
                    .padding(.horizontal, 17)
                    .padding(.top, 40)
                    .padding(.bottom, 45)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .clipShape(RoundedCorner(radius: 24, corners: [.topLeft, .topRight]))
                    .ignoresSafeArea(edges: .bottom)
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    ModalView(
        title: "작성을 완료하셨나요?",
        message: nil,
        confirmTitle: "돌아가기",
        cancelTitle: nil,
        onConfirm: {},
        onCancel: {}
    )
}
