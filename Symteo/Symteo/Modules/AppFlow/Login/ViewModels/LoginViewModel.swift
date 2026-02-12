//
//  LoginViewModel.swift
//  Symteo
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class LoginViewModel: ObservableObject {

    let providers: [SocialProvider] = SocialProvider.allCases

    private let authService: AuthServicing
    private let kakaoLoginManager: KakaoLoginManager
    private var cancellables = Set<AnyCancellable>()

    init(
        authService: AuthServicing = AuthService(),
        kakaoLoginManager: KakaoLoginManager = KakaoLoginManager()
    ) {
        self.authService = authService
        self.kakaoLoginManager = kakaoLoginManager
    }

    func tapLogin(provider: SocialProvider, onSuccess: @escaping () -> Void) {
        switch provider {
        case .kakao:
            loginWithKakao(onSuccess: onSuccess)

        case .naver, .google:
            onSuccess()
        }
    }

    private func loginWithKakao(onSuccess: @escaping () -> Void) {
        Task {
            do {
                let accessToken = try await kakaoLoginManager.loginAccessToken()

                authService.login(provider: .kakao, token: accessToken)
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                        if case let .failure(error) = completion {
                            print("로그인 실패:", error)
                        }
                    } receiveValue: { result in
                        if result.isRegistered {
                            onSuccess()
                        } else {
                            onSuccess()
                        }
                    }
                    .store(in: &cancellables)

            } catch {
                print("카카오 로그인 실패:", error)
            }
        }
    }

    private func loginWithNaver() {
        print("네이버 로그인")
    }

    private func loginWithGoogle() {
        print("구글 로그인")
    }
}
