//
//  UserDTO.swift
//  Symteo
//

import Foundation

// MARK: - Request
struct NicknameRequestDTO: Encodable {
    let nickname: String
}

// MARK: - GET /users/check-nickname
struct CheckNicknameResultDTO: Decodable {
    let isDuplicated: Bool
}

// MARK: - POST /users/signup 
struct SignupNicknameResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
    let userId: Int
    let nickname: String
    let registered: Bool
}

// MARK: - PATCH /users/nickname
struct UpdateNicknameResultDTO: Decodable {
    let nickname: String
    let profileImageUrl: String?
}
