//
//  AuthService.swift
//  Symteo
//
//  Created by 김지우 on 2/6/26.
//

import Foundation
import Combine
import Moya

/// 인증 관련 비즈니스 로직을 담당하는 프로토콜
protocol AuthServiceProtocol {
    /// 소셜 로그인 (카카오, 네이버, 구글)
    func requestSocialLogin(provider: String, token: String) -> AnyPublisher<SocialLoginResponse, APIError>
    
    /// 토큰 재발급 (Refresh Token 활용)
    func refreshAccessToken(refreshToken: String) -> AnyPublisher<RefreshResponse, APIError>
    
    /// 로그아웃 (서버 DB 내 토큰 삭제)
    func logout(refreshToken: String) -> AnyPublisher<StatusResponseOnly, APIError>
    
    /// 회원 탈퇴
    func withdraw(userId: Int) -> AnyPublisher<StatusResponseOnly, APIError>
}

final class AuthService: AuthServiceProtocol {
    
    // 1. 로그인/재발급 등 '인증 전' API용 프로바이더 (인터셉터 제외)
    private let noAuthProvider = APIManager.shared.createNoAuthProvider(for: AuthRouter.self)
    
    // 2. 로그아웃/탈퇴 등 '인증 후' API용 프로바이더 (인터셉터 포함)
    private let authProvider = APIManager.shared.createProvider(for: AuthRouter.self)
    
    /// [소셜 로그인] SDK 토큰을 서버 JWT로 교환
    func requestSocialLogin(provider: String, token: String) -> AnyPublisher<SocialLoginResponse, APIError> {
        return noAuthProvider.requestResult(
            .socialLogin(provider: provider, token: token),
            type: SocialLoginResponse.self
        )
    }
    
    /// [토큰 재발급] Access Token 만료 시 호출
    func refreshAccessToken(refreshToken: String) -> AnyPublisher<RefreshResponse, APIError> {
        return noAuthProvider.requestResult(
            .refresh(refreshToken: refreshToken),
            type: RefreshResponse.self
        )
    }
    
    /// [로그아웃] 서버 세션 종료
    func logout(refreshToken: String) -> AnyPublisher<StatusResponseOnly, APIError> {
        // 기존 MoyaProvider+Extension의 requestStatus 활용
        return authProvider.requestStatus(.logout(refreshToken: refreshToken))
    }
    
    /// [회원 탈퇴] 유저 데이터 삭제
    func withdraw(userId: Int) -> AnyPublisher<StatusResponseOnly, APIError> {
        return authProvider.requestStatus(.withdraw(userId: userId))
    }
}
