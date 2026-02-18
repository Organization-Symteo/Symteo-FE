//
//  AuthAccountDTO.swift
//  Symteo
//

import Foundation

struct AuthRefreshRequestDTO: Encodable {
    let refreshToken: String
}

struct AuthLogoutRequestDTO: Encodable {
    let refreshToken: String
}

struct AuthWithdrawRequestDTO: Encodable {
    let userId: Int
}

struct AuthRefreshResultDTO: Decodable {
    let accessToken: String
    let refreshToken: String
    let userId: Int
    let nickname: String?
    let registered: Bool
}
