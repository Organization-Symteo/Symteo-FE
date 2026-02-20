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
    case upsertSetting(request: CounselSettingRequestDTO)        // Onboarding create/upsert
    case updateSetting(request: CounselSettingRequestDTO)        // After onboarding update
    case fetchSetting

    case sendMessage(body: [String: Any])
    case endChat(request: CounselEndRequestDTO)
    case fetchReport(request: CounselReportRequestDTO)

    case fetchCounselList
    case fetchCounselDetail(chatRoomId: Int)
    case deleteCounsel(chatRoomId: Int)
}

extension ChatRouter: APITargetType {
    var baseURL: URL { URL(string: Config.baseUrl)! }

    var path: String {
        switch self {
        case .fetchSetting:
            return "/api/v1/users/counselor-settings"

        case .upsertSetting:
            return "/api/v1/counsels/setting"

        case .updateSetting:
            return "/api/v1/users/counselor-settings"

        case .sendMessage, .fetchCounselList:
            return "/api/v1/counsels"

        case .fetchReport:
            return "/api/v1/counsels/report"

        case let .endChat(request):
            return "/api/v1/counsels/\(request.chatRoomId)/summary"

        case let .fetchCounselDetail(chatRoomId),
             let .deleteCounsel(chatRoomId):
            return "/api/v1/counsels/\(chatRoomId)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .endChat: return .patch

        case .fetchSetting, .fetchCounselDetail, .fetchCounselList:
            return .get

        case .sendMessage, .fetchReport:
            return .post

        case .deleteCounsel:
            return .delete

        case .upsertSetting:
            return .put

        case .updateSetting:
            return .patch
        }
    }

    var task: Task {
        switch self {
        case let .upsertSetting(request),
             let .updateSetting(request):
            return .requestJSONEncodable(request)

        case .fetchSetting, .fetchCounselList, .fetchCounselDetail, .deleteCounsel:
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
