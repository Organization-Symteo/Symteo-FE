//
//  MoyaProvider+Extension.swift
//  Symteo
//
//  Created by 박병선 on 1/29/26.
//

import SwiftUI
import Combine
import Moya
import CombineMoya

extension MoyaProvider {

    func requestResult<T: Decodable>(
        _ target: Target,
        type: T.Type
    ) -> AnyPublisher<T, APIError> {

        return self.requestPublisher(target)
            .tryMap { moyaResponse -> T in
                // ✅ 여기서 직접 decode + RAW 출력
                let decoded: APIResponse<T>
                do {
                    decoded = try JSONDecoder().decode(APIResponse<T>.self, from: moyaResponse.data)
                } catch {
                    print("❌ decode error:", error)
                    print("RAW:", String(data: moyaResponse.data, encoding: .utf8) ?? "nil")
                    throw APIError.decodingError
                }

                if decoded.isSuccess {
                    if let result = decoded.result {
                        return result
                    } else {
                        // 성공인데 result가 nil인 케이스(명세/DTO 불일치 가능)
                        print("⚠️ isSuccess=true but result is nil")
                        print("RAW:", String(data: moyaResponse.data, encoding: .utf8) ?? "nil")
                        throw APIError.decodingError
                    }
                } else {
                    throw APIError.serverError(code: decoded.code, message: decoded.message)
                }
            }
            .mapError { error in
                if let moya = error as? MoyaError {
                    return .moyaError(moya)
                } else if let api = error as? APIError {
                    return api
                } else {
                    return .unknown
                }
            }
            .eraseToAnyPublisher()
    }

    func requestStatus(
        _ target: Target
    ) -> AnyPublisher<StatusResponseOnly, APIError> {

        return self.requestPublisher(target)
            .tryMap { moyaResponse -> StatusResponseOnly in
                // ✅ 여기서도 직접 decode + RAW 출력
                let decoded: StatusResponseOnly
                do {
                    decoded = try JSONDecoder().decode(StatusResponseOnly.self, from: moyaResponse.data)
                } catch {
                    print("❌ decode error:", error)
                    print("RAW:", String(data: moyaResponse.data, encoding: .utf8) ?? "nil")
                    throw APIError.decodingError
                }

                if decoded.isSuccess {
                    return decoded
                } else {
                    throw APIError.serverError(code: decoded.code, message: decoded.message)
                }
            }
            .mapError { error in
                if let moya = error as? MoyaError {
                    return .moyaError(moya)
                } else if let api = error as? APIError {
                    return api
                } else {
                    return .unknown
                }
            }
            .eraseToAnyPublisher()
    }
}
