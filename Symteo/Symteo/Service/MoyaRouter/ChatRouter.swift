//
//  ChatRouter.swift
//  Symteo
//
//  Created by 김지우 on 2/11/26.
//

import Foundation
import Moya
import Alamofire

enum ChatRouter {
    case saveSetting(request: CounselSettingRequestDTO)
    case sendMessage(body: [String: Any])     // chatRoomId에 null을 넣기 위해 Dictionary로 처리
    case endChat(request: CounselEndRequestDTO)
}

extension ChatRouter: APITargetType {
    var baseURL: URL { URL(string: Config.baseUrl)! }



    var path: String {
        switch self {
        case .saveSetting:
            return "/api/v1/counsels/setting"
        case .sendMessage, .endChat:
            return "/api/v1/counsels"
        }
    }

    var method: Moya.Method {
        switch self {
        case .saveSetting: return .put
        case .sendMessage: return .post
        case .endChat: return .patch
        }
    }

    var task: Task {
        switch self {
        case let .saveSetting(request):
            return .requestJSONEncodable(request)

        case let .sendMessage(body):
            // JSONEncoding + NSNull() 지원
            return .requestParameters(parameters: body, encoding: JSONEncoding.default)

        case let .endChat(request):
            return .requestJSONEncodable(request)
        }
    }

    var sampleData: Data { Data() }
}
