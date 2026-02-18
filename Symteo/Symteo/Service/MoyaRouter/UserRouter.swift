//
//  UserRouter.swift
//  Symteo
//

import Foundation
import Moya
import Alamofire

enum UserRouter {
    case checkNickname(accessToken: String, nickname: String)
    case signup(accessToken: String, dto: UserSignupRequestDTO)
}

extension UserRouter: APITargetType {
    var baseURL: URL { URL(string: Config.baseUrl)! }

    var path: String {
        switch self {
        case .checkNickname:
            return "/api/v1/users/check-nickname"
        case .signup:
            return "/api/v1/users/signup"
        }
    }

    var method: Moya.Method {
        switch self {
        case .checkNickname:
            return .get
        case .signup:
            return .post
        }
    }

    var task: Task {
        switch self {
        case let .checkNickname(_, nickname):
            return .requestParameters(parameters: ["nickname": nickname], encoding: URLEncoding.default)
        case let .signup(_, dto):
            return .requestJSONEncodable(dto)
        }
    }

    var headers: [String : String]? {
        let accessToken: String
        switch self {
        case let .checkNickname(token, _), let .signup(token, _):
            accessToken = token
        }
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
    }

    var sampleData: Data { Data() }
}
