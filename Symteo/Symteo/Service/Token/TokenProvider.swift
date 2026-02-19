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

        let newAccessToken = accessToken ?? current?.accessToken
        let newRefreshToken = refreshToken ?? current?.refreshToken

        // 둘 중 하나라도 nil이면 저장하지 않거나, 둘 다 있을 때만 저장
        guard let a = newAccessToken, !a.isEmpty,
              let r = newRefreshToken, !r.isEmpty else {
            return
        }
        keychain.saveToken(TokenInfo(accessToken: a, refreshToken: r))
    }

}
