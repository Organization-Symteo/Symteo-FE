//
//  AuthAccountService.swift
//  Symteo
//

import Foundation
import Moya

protocol AuthAccountServicing {
    func refresh(accessToken: String, refreshToken: String) async throws -> AuthRefreshResultDTO
    func logout(accessToken: String, refreshToken: String) async throws
    func withdraw(accessToken: String, userId: Int) async throws
}

final class AuthAccountService: AuthAccountServicing {

    private let provider: MoyaProvider<AuthAccountRouter>

    init(provider: MoyaProvider<AuthAccountRouter> = APIManager.shared.createNoAuthProvider(for: AuthAccountRouter.self)) {
        self.provider = provider
    }

    func refresh(accessToken: String, refreshToken: String) async throws -> AuthRefreshResultDTO {
        let dto = AuthRefreshRequestDTO(refreshToken: refreshToken)
        return try await requestResult(.refresh(accessToken: accessToken, dto: dto), type: AuthRefreshResultDTO.self)
    }

    func logout(accessToken: String, refreshToken: String) async throws {
        let dto = AuthLogoutRequestDTO(refreshToken: refreshToken)
        _ = try await requestRaw(.logout(accessToken: accessToken, dto: dto))
    }

    func withdraw(accessToken: String, userId: Int) async throws {
        let dto = AuthWithdrawRequestDTO(userId: userId)
        _ = try await requestRaw(.withdraw(accessToken: accessToken, dto: dto))
    }

    private func requestResult<T: Decodable>(_ target: AuthAccountRouter, type: T.Type) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    do {
                        let decoded = try JSONDecoder().decode(APIResponse<T>.self, from: response.data)
                        if decoded.isSuccess, let result = decoded.result {
                            continuation.resume(returning: result)
                        } else {
                            continuation.resume(throwing: APIError.serverError(code: decoded.code, message: decoded.message))
                        }
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: APIError.moyaError(error))
                }
            }
        }
    }

    private func requestRaw(_ target: AuthAccountRouter) async throws -> Response {
        try await withCheckedThrowingContinuation { continuation in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    if (200..<300).contains(response.statusCode) {
                        continuation.resume(returning: response)
                    } else {
                        continuation.resume(throwing: APIError.unauthorized)
                    }
                case .failure(let error):
                    continuation.resume(throwing: APIError.moyaError(error))
                }
            }
        }
    }
}
