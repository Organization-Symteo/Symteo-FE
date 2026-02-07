//
//  UserDTO.swift
//  Symteo
//
//  Created by 김지우 on 2/6/26.
//

import Foundation


///닉네임 중복 및 유효성 검사
struct CheckNicknameResponse: Decodable{
    let isDuplicated: Bool
}

///닉네임 등록 요청 구조체
struct SignupRequest: Encodable {
    let nickname: String
}

///닉네임 등록 응답 구조체
struct SignupResult: Decodable {
    let accessToken: String
    let refreshToken: String
    let userId: Int
    let nickname: String
    let registered: Bool //가입 완료 시 true 반환함
}
