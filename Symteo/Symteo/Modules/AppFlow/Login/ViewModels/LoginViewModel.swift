//
//  LoginViewModel.swift
//  Symteo
//

import Foundation
import Combine
import SwiftUI
@MainActor
final class LoginViewModel: ObservableObject {
    private let sessionManager: SessionManager
    private let loginRouter: LoginRouter
    private let authService: AuthServicing
    private let kakaoLoginManager: KakaoLoginManager
    private var cancellables = Set<AnyCancellable>()
    
    let providers: [SocialProvider] = SocialProvider.allCases

    init(
        sessionManager: SessionManager,
        loginRouter: LoginRouter,
        authService: AuthServicing = AuthService(),
        kakaoLoginManager: KakaoLoginManager = KakaoLoginManager()
    ) {
        self.sessionManager = sessionManager
        self.loginRouter = loginRouter
        self.authService = authService
        self.kakaoLoginManager = kakaoLoginManager
    }

    func tapLogin(provider: SocialProvider, onSuccess: @escaping () -> Void) {
        if provider == .kakao {
            loginWithKakao(onSuccess: onSuccess)
        } else {
            onSuccess()
        }
    }

    private func loginWithKakao(onSuccess: @escaping () -> Void) {
        Task {
            do {
                let accessToken = try await kakaoLoginManager.loginAccessToken()
                authService.login(provider: .kakao, token: accessToken)
                    .receive(on: DispatchQueue.main)
                    .sink { _ in } receiveValue: { [weak self] result in
                        // SessionManager 상태 업데이트 -> RootView의 flow 전환 트리거
                        self?.sessionManager.applySocialLoginResult(
                            accessToken: result.accessToken,
                            refreshToken: result.refreshToken,
                            userId: result.userId,
                            isRegistered: result.isRegistered,
                            nickname: result.nickname
                        )
                        
                        if result.isRegistered {
                            self?.loginRouter.push(.nickname)
                        } else {
                            onSuccess()
                        }
                    }
                    .store(in: &cancellables)
            } catch {
                print("로그인 실패: \(error)")
            }
        }
    }
}
