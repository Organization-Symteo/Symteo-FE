//
//  UserDTO.swift
//  Symteo
//

import Foundation

struct UserNicknameCheckResultDTO: Decodable {
    let isDuplicated: Bool
}

struct UserSignupRequestDTO: Encodable {
    let nickname: String
}

struct UserSignupResultDTO: Decodable {
    let accessToken: String
    let refreshToken: String
    let userId: Int
    let nickname: String
    let registered: Bool
}
