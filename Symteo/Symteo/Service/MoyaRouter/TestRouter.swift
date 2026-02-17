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
        guard let url = URL(string: Config.baseUrl) else {
            fatalError("Invalid Base URL: \(Config.baseUrl)")
        }
        return url
    }

    var path: String {
        switch self {
        case .createTest:
            return "/api/v1/diagnoses"
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
        return ["Content-Type": "application/json"]
    }
 
    
    var sampleData: Data {
        let json = """
        {
          "userId": 1,
          "testType": "STRESS_BURNOUT_COMPLEX",
          "answers": [
            { "questionNo": 1, "score": 1 },
            { "questionNo": 2, "score": 1 },
            { "questionNo": 3, "score": 0 },
            { "questionNo": 4, "score": 0 },
            { "questionNo": 5, "score": 0 },
            { "questionNo": 6, "score": 2 },
            { "questionNo": 7, "score": 0 },
            { "questionNo": 8, "score": 0 },
            { "questionNo": 9, "score": 0 },
            { "questionNo": 10, "score": 2 },
            { "questionNo": 11, "score": 2 },
            { "questionNo": 12, "score": 2 },
            { "questionNo": 13, "score": 2 },
            { "questionNo": 14, "score": 0 },
            { "questionNo": 15, "score": 1 },
            { "questionNo": 16, "score": 1 }
          ]
        }
        """
        return json.data(using: .utf8) ?? Data()
    }
}
