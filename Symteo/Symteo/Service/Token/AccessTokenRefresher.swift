//
//  AccessTokenRefresher.swift
//  Symteo
//
//  Created by 주민영 on 7/30/25.
//

import Foundation
import Alamofire

final class AccessTokenRefresher: @unchecked Sendable, RequestInterceptor {

    private let tokenProvider: TokenProvider

    private let lock = NSLock()
    private var isRefreshing = false
    private var requestsToRetry: [(RetryResult) -> Void] = []

    init(tokenProvider: TokenProvider = TokenProvider()) {
        self.tokenProvider = tokenProvider
    }

    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, any Error>) -> Void
    ) {
        var request = urlRequest
        if let accessToken = tokenProvider.accessToken, !accessToken.isEmpty {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        completion(.success(request))
    }

    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: any Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        guard request.retryCount < 1,
              let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 401 else {
            completion(.doNotRetry)
            return
        }

        lock.lock()
        requestsToRetry.append(completion)
        let shouldStartRefreshing = !isRefreshing
        if shouldStartRefreshing { isRefreshing = true }
        lock.unlock()

        guard shouldStartRefreshing else { return }

        refreshTokens { [weak self] result in
            guard let self else { return }

            self.lock.lock()
            let callbacks = self.requestsToRetry
            self.requestsToRetry.removeAll()
            self.isRefreshing = false
            self.lock.unlock()

            let retryResult: RetryResult = result.isSuccess ? .retry : .doNotRetry
            callbacks.forEach { $0(retryResult) }
        }
    }

    private func refreshTokens(completion: @escaping (RefreshAttemptResult) -> Void) {
        guard let refreshToken = tokenProvider.refreshToken,
              !refreshToken.isEmpty else {
            completion(.init(isSuccess: false))
            return
        }

        let url = URL(string: "\(Config.baseUrl)/api/v1/auth/refresh")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let accessToken = tokenProvider.accessToken, !accessToken.isEmpty {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }

        do {
            request.httpBody = try JSONEncoder().encode(RefreshRequestDTO(refreshToken: refreshToken))
        } catch {
            completion(.init(isSuccess: false))
            return
        }

        AF.request(request)
            .responseData { [weak self] response in
                guard let self else { return }

                switch response.result {
                case .success(let data):
                    do {
                        let envelope = try JSONDecoder().decode(RefreshEnvelopeDTO.self, from: data)
                        guard envelope.isSuccess, let result = envelope.result else {
                            completion(.init(isSuccess: false))
                            return
                        }

                        self.tokenProvider.setTokens(accessToken: result.accessToken, refreshToken: result.refreshToken)
                        completion(.init(isSuccess: true))
                    } catch {
                        completion(.init(isSuccess: false))
                    }

                case .failure:
                    completion(.init(isSuccess: false))
                }
            }
    }
}

private struct RefreshAttemptResult {
    let isSuccess: Bool
}

private struct RefreshRequestDTO: Encodable {
    let refreshToken: String
}

private struct RefreshEnvelopeDTO: Decodable {
    let isSuccess: Bool
    let code: String?
    let message: String?
    let result: RefreshResultDTO?
}

private struct RefreshResultDTO: Decodable {
    let accessToken: String
    let refreshToken: String
    let userId: Int
    let nickname: String?
    let isRegistered: Bool
}
