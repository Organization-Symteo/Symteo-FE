//
//  HomeRouter.swift
//  Symteo
//
//  Created by 박병선 on 2/1/26.
//
import Foundation
import Moya
import Alamofire

enum HomeRouter {
    case updateTodayWeather(weather: Int) // 감정 날씨 수정(Request Body 없음)
    case fetchHome // 홈 화면 전체 내용 조회
}

extension HomeRouter: APITargetType {
    var baseURL: URL { URL(string: Config.baseUrl)! }

    var path: String {
        switch self {
        case .updateTodayWeather:
            return "/api/v1/home/today-emotion" // /api/v1/home/today-weather?weather={}
        case .fetchHome:
            return "/api/v1/home"
        }
    }

    var method: Moya.Method {
        switch self {
        case .updateTodayWeather:
            return .patch
        case .fetchHome:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .updateTodayWeather(let weather):
            return .requestParameters(parameters: ["weather": weather], encoding: URLEncoding.queryString)
        case .fetchHome:
            return .requestPlain
        }
    }

    /*
    var headers: [String : String]? {
        ["Content-Type": "application/json"]
    } */
    
    
    var sampleData: Data {
        switch self {
        case .updateTodayWeather:
            return  """
        {
          "isSuccess": true,
          "code": "2000",
          "message": "Ok",
          "result": 2
        }
        """.data(using: .utf8)!
            
        case .fetchHome:
            return  """
        {
          "isSuccess": true,
          "code": "2000",
          "message": "Ok",
          "result": {
            "todayLine": "당신의 앞길에 꽃길만 펼쳐지길 진심으로 바랄게요.",
            "todayWeather": 1,
            "nickname": "심터데모"
          }
        }
        """.data(using: .utf8)!
        }
       
    }
}
