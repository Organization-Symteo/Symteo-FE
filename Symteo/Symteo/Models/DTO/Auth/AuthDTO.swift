//
//  AuthDTO.swift
//  Symteo
//
//  Created by 김지우 on 2/12/26.
//

import Foundation


/// Kakao 로그인 후 공통으로 사용될 사용자 데이터 전달용 프로토콜
protocol KakaoDTO {
    
    /// 카카오에서 발급된 토큰
    var idToken: String { get }
}

/// Kakao 로그인 요청 구조체
/// KakaoDTO 프로토콜을 채택하여 공통 인터페이스를 제공
struct KakaoUser: KakaoDTO, Codable {
    var idToken: String
    var fcmToken: String?
}


// MARK: - Provider
/// Path parameter로 들어가는 provider (실제 요청은 소문자여도 서버가 대/소문자 무관 처리)
enum SocialProviderDTO: String, Codable, CaseIterable {
    case kakao = "kakao"
    case naver = "naver"
    case google = "google"
}

// MARK: - Request
/// POST /api/v1/auth/login/{provider}
struct SocialLoginRequestDTO: Encodable {
    let accessToken: String
}

// (명세 하단에 authCode 기반도 같이 표기되어 있어서, 필요하면 대비용으로 같이 둠)
/// POST /api/v1/auth/login/{provider} (code/state 버전이 별도 엔드포인트로 나오면 사용)
struct SocialAuthCodeLoginRequestDTO: Encodable {
    let code: String
    let state: String?
}

// MARK: - Response (result)
struct SocialLoginResultDTO: Decodable, Hashable {
    let accessToken: String
    let refreshToken: String
    let userId: Int
    let nickname: String?
    let isRegistered: Bool
}

struct TokenReissueRequestDTO: Encodable {
    let refreshToken: String
}

/*
struct TokenReissueResultDTO: Decodable, Hashable, Sendable {
    let accessToken: String
    let refreshToken: String
    let userId: Int
    let nickname: String?
    let registered: Bool
}
 SocialLoginResultDTO와 구조 같은 관계로 SocialLoginResultDTO 재사용
 */


