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
                    .sink(
                        receiveCompletion: { completion in
                            if case let .failure(error) = completion {
                                print("로그인 실패: \(error)")
                            }
                        },
                        receiveValue: { [weak self] result in
                            guard let self else { return }

                            self.sessionManager.applySocialLoginResult(
                                accessToken: result.accessToken,
                                refreshToken: result.refreshToken,
                                userId: result.userId,
                                isRegistered: result.isRegistered,
                                nickname: result.nickname
                            )

                            if result.isRegistered {
                                onSuccess()
                            } else {
                                self.loginRouter.push(.nickname)
                            }
                        }
                    )
                    .store(in: &cancellables)
            } catch {
                print("로그인 실패: \(error)")
            }
        }
    }
}

@MainActor
final class AccountViewModel: ObservableObject {

    @Published var lastErrorMessage: String? = nil
    @Published var isLoading: Bool = false

    private weak var sessionManager: SessionManager?
    private let tokenProvider: TokenProvider
    private let authAccountService: AuthAccountServicing

    init(
        sessionManager: SessionManager? = nil,
        tokenProvider: TokenProvider = TokenProvider(),
        authAccountService: AuthAccountServicing = AuthAccountService()
    ) {
        self.sessionManager = sessionManager
        self.tokenProvider = tokenProvider
        self.authAccountService = authAccountService
    }

    func bind(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
    }

    func logout() {
        guard let accessToken = tokenProvider.accessToken, !accessToken.isEmpty,
              let refreshToken = tokenProvider.refreshToken, !refreshToken.isEmpty else {
            sessionManager?.logout()
            return
        }

        isLoading = true
        lastErrorMessage = nil

        Task {
            defer { isLoading = false }
            do {
                try await authAccountService.logout(accessToken: accessToken, refreshToken: refreshToken)
                sessionManager?.logout()
            } catch {
                sessionManager?.logout()
            }
        }
    }

    func withdraw() {
        guard let manager = sessionManager,
              let userId = manager.userId,
              let accessToken = tokenProvider.accessToken, !accessToken.isEmpty else {
            sessionManager?.logout()
            return
        }

        isLoading = true
        lastErrorMessage = nil

        Task {
            defer { isLoading = false }
            do {
                try await authAccountService.withdraw(accessToken: accessToken, userId: userId)
                sessionManager?.logout()
            } catch {
                sessionManager?.logout()
            }
        }
    }
}
