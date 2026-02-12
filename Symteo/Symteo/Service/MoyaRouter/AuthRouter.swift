//
//  AuthRouter.swift
//  Symteo
//
//  Created by 김지우 on 2/12/26.
//

import Foundation
import Moya
import Alamofire

enum AuthRouter {
    /// 소셜 플랫폼 access token을 전달해서 서버 JWT(Access+Refresh) 받기
    case socialTokenLogin(provider: SocialProviderDTO, dto: SocialLoginRequestDTO)

    /// (예비) authCode/state 기반 로그인 (백엔드에서 이 버전을 별도 엔드포인트로 분리하면 path만 바꾸면 됨)
    case socialAuthCodeLogin(provider: SocialProviderDTO, dto: SocialAuthCodeLoginRequestDTO)
}

extension AuthRouter: APITargetType {

    var baseURL: URL {
        URL(string: "\(Config.baseUrl)")!
    }
    
    var path: String {
        switch self {
        case let .socialTokenLogin(provider, _),
             let .socialAuthCodeLogin(provider, _):
            // 명세: /auth/login/{provider}
            return "/api/v1/auth/login/\(provider.rawValue)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .socialTokenLogin, .socialAuthCodeLogin:
            return .post
        }
    }

    var task: Task {
        switch self {
        case let .socialTokenLogin(_, dto):
            return .requestJSONEncodable(dto)

        case let .socialAuthCodeLogin(_, dto):
            return .requestJSONEncodable(dto)
        }
    }

    var headers: [String : String]? {

        return ["Content-Type": "application/json"]
    }

    var sampleData: Data {
        return Data()
    }
}
