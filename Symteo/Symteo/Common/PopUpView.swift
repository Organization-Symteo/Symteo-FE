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
    let cancelTitle: String
    let onConfirm: () -> Void
    let onCancel: () -> Void
    
    // MARK: - Animation properties
    @State private var appearScale: CGFloat = 0.8
    @State private var opacity: Double = 0

    var body: some View {
        ZStack {
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
                
                HStack(spacing: 9) {
                    PopupCancelButton(
                        text: cancelTitle,
                        action: onCancel
                    )
                    .frame(maxWidth: .infinity, minHeight: 48, maxHeight: 48)

                    PopupConfirmButton(
                        text: confirmTitle,
                        action: onConfirm
                    )
                    .frame(maxWidth: .infinity, minHeight: 48, maxHeight: 48)
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
            .onAppear {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                    appearScale = 1.0
                    opacity = 1.0
                }
            }
        }
    }
}

struct PopupConfirmButton: View {
    let text: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.PretendardSemiBold(size: 16))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.maingreen)
                )
        }
        .buttonStyle(.plain)
    }
}

struct PopupCancelButton: View {
    let text: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.PretendardSemiBold(size: 16))
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray100, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack {
        PopUpView(
            title: "수정을 취소하시겠어요?",
            message: " 지금 나가시면 변경된 내용이 저장되지 않아요.",
            confirmTitle: "나가기",
            cancelTitle: "계속 수정하기",
            onConfirm: {},
            onCancel: {}
        )
        PopUpView(
            title: "상담을 종료하시겠습니까?",
            message: nil,
            confirmTitle: "삭제",
            cancelTitle: "취소",
            onConfirm: {},
            onCancel: {}
        )
    }
}
