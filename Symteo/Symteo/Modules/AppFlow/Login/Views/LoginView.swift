//
//  LoginView.swift
//  Symteo
//
//  Created by 김지우 on 1/12/26.
//
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var loginRouter: LoginRouter
    @StateObject private var viewModel: LoginViewModel

    init(sessionManager: SessionManager, loginRouter: LoginRouter) {
        _viewModel = StateObject(wrappedValue: LoginViewModel(
            sessionManager: sessionManager,
            loginRouter: loginRouter
        ))
    }

    @AppStorage("AgreeTerms") private var agreeTerms: Bool = false
    @State private var showTermsPopup: Bool = false
    @State private var termsSheet: TermsSheetType? = nil

    var body: some View {
        ZStack {
            VStack(spacing: 8) {
                logoview
                Spacer().frame(height: 16)

                ForEach(viewModel.providers, id: \.self) { provider in
                    SocialLoginButton(icon: provider.icon, title: provider.title) {
                        if !agreeTerms {
                            withAnimation(.spring()) {
                                showTermsPopup = true
                            }
                        } else {
                            viewModel.tapLogin(provider: provider) { }
                        }
                    }
                }

                Spacer().frame(height: 77)
                termsRow
            }
            .padding(.horizontal, 26)
            .allowsHitTesting(!showTermsPopup)
        }
        .overlay {
            if showTermsPopup {
                ZStack {
                    Color.black.opacity(0.35).ignoresSafeArea()

                    PopUpView(
                        title: "심터의 이용약관 및 개인정보 취급방침에\n동의하고 시작합니다.",
                        message: "",
                        confirmTitle: "동의하기",
                        cancelTitle: "동의하지 않기",
                        onConfirm: {
                            agreeTerms = true
                            showTermsPopup = false
                        },
                        onCancel: {
                            showTermsPopup = false
                        }
                    )
                    .transition(.scale.combined(with: .opacity))
                }
                .zIndex(999)
            }
        }
        .task {
            agreeTerms = false
            if !agreeTerms {
                await Task.yield()
                showTermsPopup = true
            }
        }
        .sheet(item: $termsSheet) { sheet in
            TermsBottomSheet(type: sheet)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }

    private var logoview: some View {
        VStack {
            Image(.symlogoBig)
                .resizable()
                .scaledToFit()
                .frame(height: 420)
                .frame(maxWidth: .infinity)
                .clipped()

            Text("나만의 멘탈 케어 솔루션")
                .font(.PretendardMedium(size: 16))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var termsRow: some View {
        HStack(spacing: 2) {
            Button { termsSheet = .safeTerms } label: { Text("안심 이용약관") }
                .buttonStyle(.plain)

            Text("&")
                .foregroundStyle(.gray400)

            Button { termsSheet = .dataConsent } label: { Text("데이터 처리 동의") }
                .buttonStyle(.plain)
        }
        .font(.PretendardMedium(size: 14))
        .foregroundStyle(Color.gray400)
    }
}
