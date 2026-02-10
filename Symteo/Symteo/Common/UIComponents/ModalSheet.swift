//
//  ModalSheet.swift
//  Symteo
//
//  Created by 박정환 on 1/9/26.
//

import SwiftUI

private struct ModalSheetContent: View {
    let title: String
    let message: String?
    let confirmTitle: String
    let cancelTitle: String?
    let onConfirm: () -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.PretendardSemiBold(size: 16))
                .foregroundStyle(.gray900)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)

            Spacer().frame(height: 10)

            if let message = message {
                Text(message)
                    .font(.PretendardRegular(size: 12))
                    .foregroundStyle(.gray700)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity)

                Spacer().frame(height: 24)
            } else {
                Spacer().frame(height: 24)
            }

            if let cancelTitle = cancelTitle {
                HStack(spacing: 10) {
                    PopupCancelButton(text: cancelTitle, action: onCancel)
                        .frame(maxWidth: .infinity, minHeight: 48, maxHeight: 48)

                    PopupConfirmButton(text: confirmTitle, action: onConfirm)
                        .frame(maxWidth: .infinity, minHeight: 48, maxHeight: 48)
                }
            } else {
                PopupConfirmButton(text: confirmTitle, action: onConfirm)
                    .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56)
            }
        }
        .padding(.horizontal, 17)
        .padding(.top, 48)
        .padding(.bottom, 40)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

private struct ModalPopupPresenter: ViewModifier {
    @Binding var isPresented: Bool

    let title: String
    let message: String?
    let confirmTitle: String
    let cancelTitle: String?
    let dismissOnBackgroundTap: Bool
    let onConfirm: () -> Void
    let onCancel: () -> Void

    func body(content: Content) -> some View {
        ZStack {
            content

            if isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        guard dismissOnBackgroundTap else { return }
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isPresented = false
                        }
                    }
                    .transition(.opacity)

                VStack {
                    Spacer()

                    ModalSheetContent(
                        title: title,
                        message: message,
                        confirmTitle: confirmTitle,
                        cancelTitle: cancelTitle,
                        onConfirm: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isPresented = false
                            }
                            onConfirm()
                        },
                        onCancel: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isPresented = false
                            }
                            onCancel()
                        }
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                .ignoresSafeArea(edges: .bottom)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isPresented)
    }
}

extension View {
    func modalPopup(
        isPresented: Binding<Bool>,
        title: String,
        message: String? = nil,
        confirmTitle: String,
        cancelTitle: String? = nil,
        dismissOnBackgroundTap: Bool = false,
        onConfirm: @escaping () -> Void,
        onCancel: @escaping () -> Void = {}
    ) -> some View {
        modifier(
            ModalPopupPresenter(
                isPresented: isPresented,
                title: title,
                message: message,
                confirmTitle: confirmTitle,
                cancelTitle: cancelTitle,
                dismissOnBackgroundTap: dismissOnBackgroundTap,
                onConfirm: onConfirm,
                onCancel: onCancel
            )
        )
    }
}
