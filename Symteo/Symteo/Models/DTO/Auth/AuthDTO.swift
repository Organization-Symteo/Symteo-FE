//
//  AuthDTO.swift
//  Symteo
//
//  Created by 김지우 on 2/5/26.
//

import Foundation

/// 소셜 로그인 요청을 위한 DTO
struct SocialLoginRequest: Encodable {
    let code: String //소셜 플랫폼에서 받은 Access token

}

/// 소셜 로그인 성공 시 반환되는 데이터 모델
struct SocialLoginResponse: Decodable {
    let accessToken: String
    let refreshToken: String
    let userId: Int
    let nickname: String? // 신규 회원의 경우 null
    let registered: Bool // true = 기존 회원, false = 신규 회원
}


/// 토큰 재발급 요청 구조체
struct RefreshRequest: Codable {
    let refreshToken: String
}

/// 토큰 재발급 응답 구조체
struct RefreshResponse: Codable {
    let accessToken: String
    let accessTokenExpireAt: String
}

/// 로그아웃 요청 구조체
struct LogoutRequest: Encodable {
    let refreshToken: String
}

///회원탈퇴 요청 구조체
struct WithdrawRequest: Codable{
    let userId: Int
}
