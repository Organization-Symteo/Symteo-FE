//
//  KakaoLoginManaver.swift
//  Symteo
//
//  Created by 김지우 on 2/12/26.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKUser

final class KakaoLoginManager {

    @MainActor
    public func loginAccessToken() async throws -> String {
        let token: OAuthToken

        if UserApi.isKakaoTalkLoginAvailable() {
            token = try await loginWithKakaoApp()
        } else {
            token = try await loginWithKakaoWeb()
        }

        return token.accessToken
    }

    @MainActor
    private func loginWithKakaoApp() async throws -> OAuthToken {
        try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk { token, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let token = token {
                    continuation.resume(returning: token)
                } else {
                    continuation.resume(throwing: KakaoLoginError.failedToLoginWithKakaoApp)
                }
            }
        }
    }

    @MainActor
    private func loginWithKakaoWeb() async throws -> OAuthToken {
        try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount { token, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let token = token {
                    continuation.resume(returning: token)
                } else {
                    continuation.resume(throwing: KakaoLoginError.failedToLoginWithKakaoWeb)
                }
            }
        }
    }
}
