//
//  UserRouter.swift
//  Symteo
//

import Foundation
import Moya
import Alamofire

enum UserRouter {
    case checkNickname(nickname: String)
    case signup(request: NicknameRequestDTO)
    case updateNickname(request: NicknameRequestDTO)
}

extension UserRouter: APITargetType {

    var baseURL: URL { URL(string: Config.baseUrl)! }

    var path: String {
        switch self {
        case .checkNickname:
            return "/api/v1/users/check-nickname"
        case .signup:
            return "/api/v1/users/signup"
        case .updateNickname:
            return "/api/v1/users/nickname"
        }
    }

    var method: Moya.Method {
        switch self {
        case .checkNickname: return .get
        case .signup: return .post
        case .updateNickname: return .patch
        }
    }

    var task: Task {
        switch self {
        case let .checkNickname(nickname):
            return .requestParameters(parameters: ["nickname": nickname], encoding: URLEncoding.queryString)

        case let .signup(request),
             let .updateNickname(request):
            return .requestJSONEncodable(request)
        }
    }

    var sampleData: Data { Data() }
}
