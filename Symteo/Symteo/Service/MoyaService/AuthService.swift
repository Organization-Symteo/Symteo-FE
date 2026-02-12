//
//  AuthService.swift
//  Symteo
//
//  Created by 김지우 on 2/12/26.
//

import Foundation
import Combine
import Moya

protocol AuthServicing {
    /// 소셜 토큰 기반 로그인
    func login(provider: SocialProviderDTO, token: String) -> AnyPublisher<SocialLoginResultDTO, APIError>

    /// (예비) authCode 기반 로그인
    func loginWithAuthCode(
        provider: SocialProviderDTO,
        code: String,
        state: String?
    ) -> AnyPublisher<SocialLoginResultDTO, APIError>
}

final class AuthService: AuthServicing {

    private let provider: MoyaProvider<AuthRouter>
    private let tokenProvider: TokenProvider

    /// 기본값: 로그인/회원가입은 토큰 인터셉터 없이 호출해야 안전함
    init(
        provider: MoyaProvider<AuthRouter> = APIManager.shared.createNoAuthProvider(for: AuthRouter.self),
        tokenProvider: TokenProvider = TokenProvider()
    ) {
        self.provider = provider
        self.tokenProvider = tokenProvider
    }

    // MARK: - Login (Social Token)
    func login(provider: SocialProviderDTO, token: String) -> AnyPublisher<SocialLoginResultDTO, APIError> {
        let dto = SocialLoginRequestDTO(accessToken: token)

        return self.provider
            .requestResult(.socialTokenLogin(provider: provider, dto: dto), type: SocialLoginResultDTO.self)
            .handleEvents(receiveOutput: { [weak self] result in
                // 서버가 발급한 JWT 저장
                self?.tokenProvider.setTokens(accessToken: result.accessToken, refreshToken: result.refreshToken)
            })
            .eraseToAnyPublisher()
    }

    // MARK: - Login (AuthCode) - Optional
    func loginWithAuthCode(
        provider: SocialProviderDTO,
        code: String,
        state: String?
    ) -> AnyPublisher<SocialLoginResultDTO, APIError> {
        let dto = SocialAuthCodeLoginRequestDTO(code: code, state: state)

        return self.provider
            .requestResult(.socialAuthCodeLogin(provider: provider, dto: dto), type: SocialLoginResultDTO.self)
            .handleEvents(receiveOutput: { [weak self] result in
                self?.tokenProvider.setTokens(accessToken: result.accessToken, refreshToken: result.refreshToken)
            })
            .eraseToAnyPublisher()
    }
}
