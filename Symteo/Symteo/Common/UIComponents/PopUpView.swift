//
//  PopUpView.swift
//  Symteo
//
//  Created by 박정환 on 1/9/26.
//

import SwiftUI

struct PopUpView: View {
    let title: String
    let message: String?
    let confirmTitle: String
    let cancelTitle: String?
    let onConfirm: () -> Void
    let onCancel: () -> Void
    
    // MARK: - Animation properties
    @State private var appearScale: CGFloat = 0.8
    @State private var opacity: Double = 0

    var body: some View {
        ZStack {
            Color.black
                .opacity(opacity * 0.4)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                // 제목
                Text(title)
                    .font(.PretendardMedium(size: 16))
                    .foregroundColor(.gray900)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                
                Spacer().frame(height: 6)
                
                // 메시지
                if let message = message {
                    Text(message)
                        .font(.PretendardMedium(size: 14))
                        .foregroundColor(.gray700)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity)

                }
                
                Spacer().frame(height: 20)
                
                if let cancelTitle = cancelTitle {
                    HStack(spacing: 9) {
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
            .padding(.horizontal, 22)
            .padding(.vertical, 30)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(
                        color: Color.black.opacity(0.25),
                        radius: 4,
                        x: 0,
                        y: 0
                    )
            )
            .padding(.horizontal, 19)
            .scaleEffect(appearScale)
            .opacity(opacity)
            .transition(.scale.combined(with: .opacity))
            .onAppear {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                    appearScale = 1.0
                    opacity = 1.0
                }
            }
        }
    }
}

#Preview {
    VStack {
        PopUpView(
            title: "수정을 취소하시겠어요?",
            message: nil,
            confirmTitle: "나가기",
            cancelTitle: "계속 수정하기",
            onConfirm: {},
            onCancel: {}
        )
        PopUpView(
            title: "심터 문의",
            message: "cs@symteo.com로 이메일을 보내주세요.",
            confirmTitle: "확인",
            cancelTitle: nil,
            onConfirm: {},
            onCancel: {}
        )
    }
}
