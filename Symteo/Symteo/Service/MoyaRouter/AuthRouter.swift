//
//  AuthRouter.swift
//  Symteo
//
//  Created by 김지우 on 2/5/26.
//

import Foundation
import Moya
import Alamofire

enum AuthRouter {
    case socialLogin(provider: String, token: String)
    case refresh(refreshToken: String)
    case logout(refreshToken: String)
    case withdraw(userId: Int)
}

extension AuthRouter: APITargetType {
    
    ///서버 주소
    var baseURL: URL {
        return URL(string: "https://api.symteo.com")!
    }

    var path: String {
        switch self {
        case .socialLogin(let provider, _):
            return "/api/v1/auth/login/\(provider)"
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
        case .socialLogin, .refresh, .logout:
            return .post
        case .withdraw:
            return .delete
        }
    }

    var task: Task {
        switch self {
        case .socialLogin(_, let token):
            return .requestJSONEncodable(SocialLoginRequest(token: token))
        case .refresh(let refreshToken):
            return .requestJSONEncodable(RefreshRequest(refreshToken: refreshToken))
        case .logout(let refreshToken):
            return .requestJSONEncodable(LogoutRequest(refreshToken: refreshToken))
        case .withdraw(let userId):
            return .requestJSONEncodable(WithdrawRequest(userId: userId))
        }
    }
}
