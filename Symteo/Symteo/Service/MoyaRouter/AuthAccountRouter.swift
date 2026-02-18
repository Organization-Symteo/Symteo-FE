//
//  AuthAccountRouter.swift
//  Symteo
//

import Foundation
import Moya
import Alamofire

enum AuthAccountRouter {
    case refresh(accessToken: String, dto: AuthRefreshRequestDTO)
    case logout(accessToken: String, dto: AuthLogoutRequestDTO)
    case withdraw(accessToken: String, dto: AuthWithdrawRequestDTO)
}

extension AuthAccountRouter: APITargetType {
    var baseURL: URL { URL(string: Config.baseUrl)! }

    var path: String {
        switch self {
        case .refresh:
            return "/api/v1/auth/refresh"
        case .logout:
            return "/api/v1/auth/logout"
        case .withdraw:
            return "/api/v1/auth/withdraw"
        }
    }

    var method: Moya.Method {
        switch self {
        case .withdraw:
            return .delete
        case .refresh, .logout:
            return .post
        }
    }

    var task: Task {
        switch self {
        case let .refresh(_, dto):
            return .requestJSONEncodable(dto)
        case let .logout(_, dto):
            return .requestJSONEncodable(dto)
        case let .withdraw(_, dto):
            return .requestJSONEncodable(dto)
        }
    }

    var headers: [String : String]? {
        let accessToken: String
        switch self {
        case let .refresh(token, _), let .logout(token, _), let .withdraw(token, _):
            accessToken = token
        }
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
    }

    var sampleData: Data { Data() }
}
