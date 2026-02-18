//
//  TokenProvider.swift
//  Symteo
//
//  Created by 박병선 on 1/29/26.
//

import Foundation

final class TokenProvider: TokenProviding {

    private let keychain = KeychainService.shared

    var accessToken: String? {
        get { keychain.loadToken()?.accessToken }
        set { upsertTokens(accessToken: newValue, refreshToken: nil) }
    }

    var refreshToken: String? {
        get { keychain.loadToken()?.refreshToken }
        set { upsertTokens(accessToken: nil, refreshToken: newValue) }
    }

    func setTokens(accessToken: String, refreshToken: String) {
        let tokenInfo = TokenInfo(accessToken: accessToken, refreshToken: refreshToken)
        keychain.saveToken(tokenInfo)
    }

    func clearTokens() {
        _ = keychain.deleteToken()
    }

    private func upsertTokens(accessToken: String?, refreshToken: String?) {
        let current = keychain.loadToken()

        let newAccessToken: String = {
            if let accessToken { return accessToken }
            return current?.accessToken ?? ""
        }()

        let newRefreshToken: String = {
            if let refreshToken { return refreshToken }
            return current?.refreshToken ?? ""
        }()

        let tokenInfo = TokenInfo(accessToken: newAccessToken, refreshToken: newRefreshToken)
        keychain.saveToken(tokenInfo)
    }
}
