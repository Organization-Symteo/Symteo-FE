//
//  TestRouter.swift
//  Symteo
//
//  Created by 김지우 on 2/10/26.
//



import Foundation
import Moya
import Alamofire

enum TestRouter {
    case createTest(request: CreateTestRequestDTO)
}

extension TestRouter: APITargetType {
    var baseURL: URL {
        URL(string: "\(Config.baseUrl)")!
    }

    var path: String {
        switch self {
        case .createTest:
            return "/api/v1/tests"
        }
    }

    var method: Moya.Method {
        switch self {
        case .createTest:
            return .post
        }
    }

    var task: Task {
        switch self {
        case let .createTest(request):
            return .requestJSONEncodable(request)
        }
    }

    var headers: [String : String]? {
        ["Content-Type": "application/json"]
    }
}

