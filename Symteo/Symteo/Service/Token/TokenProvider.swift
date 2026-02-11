//
//  TokenProvider.swift
//  Symteo
//
//  Created by 박병선 on 1/29/26.
//
import Foundation
import Moya

import Foundation
import Moya

final class TokenProvider: TokenProviding {

    private let keyChain = KeychainService.shared

    var accessToken: String? {
        get {
            if let userInfo = keyChain.loadToken(),
               !userInfo.accessToken.isEmpty,
               userInfo.accessToken != "토큰 정보 없음" {
                return userInfo.accessToken
            }
            return Config.devToken
        }
        set {
            guard var userInfo = keyChain.loadToken() else { return }
            userInfo.accessToken = newValue ?? "토큰 정보 없음"
            keyChain.saveToken(userInfo)
        }
    }

    var refreshToken: String? {
        get {
            guard let userInfo = keyChain.loadToken() else { return nil }
            return userInfo.refreshToken
        }
        set {
            guard var userInfo = keyChain.loadToken() else { return }
            userInfo.refreshToken = newValue ?? "토큰 정보 없음"
            keyChain.saveToken(userInfo)
        }
    }
}
