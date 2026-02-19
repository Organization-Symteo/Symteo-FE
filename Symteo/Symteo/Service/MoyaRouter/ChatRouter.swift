//  ChatRouter.swift
//  Symteo
//
//  Created by 김지우 on 2/11/26.
//

import Foundation
import Moya
import Alamofire

enum ChatRouter {
    case upsertSetting(request: CounselSettingRequestDTO)
    case fetchSetting
    case sendMessage(body: [String: Any])
    case endChat(request: CounselEndRequestDTO)
    case fetchReport(request: CounselReportRequestDTO)
}

extension ChatRouter: APITargetType {
    var baseURL: URL { URL(string: Config.baseUrl)! }

    var path: String {
        switch self {
        case .upsertSetting, .fetchSetting:
            return "/api/v1/users/counselor-settings"
        case .sendMessage:
            return "/api/v1/counsels"
        case .fetchReport:
            return "/api/v1/counsels/report"
        case let .endChat(request):
            return "/api/v1/counsels/\(request.chatRoomId)/summary"
        }
    }

    var method: Moya.Method {
        switch self {
        case .upsertSetting: return .patch
        case .fetchSetting: return .get
        case .sendMessage,.fetchReport : return .post
        case .endChat: return .patch
        }
    }

    var task: Task {
        switch self {
        case let .upsertSetting(request):
            return .requestJSONEncodable(request)

        case .fetchSetting:
            return .requestPlain

        case let .sendMessage(body):
            return .requestParameters(parameters: body, encoding: JSONEncoding.default)

        case let .endChat(request):
            return .requestJSONEncodable(request)

        case let .fetchReport(request):
            return .requestJSONEncodable(request)
        }
    }

    var sampleData: Data { Data() }
}

