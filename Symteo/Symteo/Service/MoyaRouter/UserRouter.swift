//
//  UserRouter.swift
//  Symteo
//
//  Created by 김지우 on 2/6/26.
//


import Foundation
import Moya
import Alamofire

enum UserRouter {
    case checkNickname(nickname: String)
}

extension UserRouter: APITargetType {
    var baseURL: URL { URL(string: "https://api.symteo.com")! }

    var path: String {
        switch self {
        case .checkNickname:
            return "/api/v1/users/check-nickname"
        }
    }

    var method: Moya.Method { .get }

    var task: Task {
        switch self {
        case .checkNickname(let nickname):
            // 쿼리 파라미터로 nickname 전달
            return .requestParameters(
                parameters: ["nickname": nickname],
                encoding: URLEncoding.queryString
            )
        }
    }
}
