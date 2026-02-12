//
//  AccessTokenRefresher.swift
//  Symteo
//
//  Created by 박병선 on 1/29/26.
//

import Foundation
import Alamofire

final class AccessTokenRefresher: @unchecked Sendable, RequestInterceptor {

    private let tokenProviding: TokenProviding

    init(tokenProviding: TokenProviding) {
        self.tokenProviding = tokenProviding
    }

    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var request = urlRequest

        if let token = tokenProviding.accessToken, !token.isEmpty {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        completion(.success(request))
    }
}
