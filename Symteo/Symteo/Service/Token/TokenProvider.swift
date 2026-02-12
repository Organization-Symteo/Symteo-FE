//
//  TokenProvider.swift
//  Symteo
//
//  Created by 박병선 on 1/29/26.
//

import Foundation
import Moya

final class TokenProvider: TokenProviding {

    private let keyChain = KeychainService.shared

    var accessToken: String? {
        get { keyChain.loadToken()?.accessToken }
        set { upsertTokens(accessToken: newValue, refreshToken: nil) }
    }

    var refreshToken: String? {
        get { keyChain.loadToken()?.refreshToken }
        set { upsertTokens(accessToken: nil, refreshToken: newValue) }
    }

    func setTokens(accessToken: String, refreshToken: String) {
        upsertTokens(accessToken: accessToken, refreshToken: refreshToken)
    }

    func clearTokens() {
        keyChain.deleteToken()
    }

    private func upsertTokens(accessToken: String?, refreshToken: String?) {
        if var userInfo = keyChain.loadToken() {
            if let accessToken { userInfo.accessToken = accessToken }
            if let refreshToken { userInfo.refreshToken = refreshToken }
            keyChain.saveToken(userInfo)
        } else {
            let userInfo = TokenInfo(
                accessToken: accessToken ?? "",
                refreshToken: refreshToken ?? ""
            )
            keyChain.saveToken(userInfo)
        }
    }
}
