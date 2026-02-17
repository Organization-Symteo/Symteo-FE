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
    case sendMessage(body: [String: Any])
    case endChat(request: CounselEndRequestDTO)
    case fetchReport(query: [String: Any])
}

extension ChatRouter: APITargetType {
    var baseURL: URL { URL(string: Config.baseUrl)! }

    var path: String {
        switch self {
        case .saveSetting:
            return "/api/v1/counsels/setting"
        case .sendMessage, .endChat:
            return "/api/v1/counsels"
        case .fetchReport:
            return "/api/v1/counsels/report"
        }
    }

    var method: Moya.Method {
        switch self {
        case .saveSetting: return .put
        case .sendMessage: return .post
        case .endChat: return .patch
        case .fetchReport: return .get
        }
    }

    var task: Task {
        switch self {
        case let .saveSetting(request):
            return .requestJSONEncodable(request)

        case let .sendMessage(body):
            return .requestParameters(parameters: body, encoding: JSONEncoding.default)

        case let .endChat(request):
            return .requestJSONEncodable(request)

        case let .fetchReport(query):
            return .requestParameters(parameters: query, encoding: URLEncoding.queryString)
        }
    }

    var sampleData: Data { Data() }
}
