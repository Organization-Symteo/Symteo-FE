//
//  MissionRouter.swift
//  Symteo
//
//  Created by 박병선 on 2/1/26.
//
import Foundation
import Moya
import Alamofire

enum MissionRouter {
    case fetchTodayMission // 오늘의 미션 조회
    case submitMission(missionId: Int, data: MissionStartRequest) // 미션 제출 시작
    case saveMissionDraft(userMissionId: Int, data: MissionDraftRequest) // 미션 텍스트 제출
    case completeMission(userMissionId: Int) // 미션 제출 완료
    case restartTodayMission // 미션 새로고침
}

extension MissionRouter: APITargetType {
    var baseURL: URL {
        print("Config.baseUrl =", Config.baseUrl)

        guard let url = URL(string: Config.baseUrl) else {
            fatalError("잘못된 BASE_URL: \(Config.baseUrl)")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .fetchTodayMission:
            return "/api/v1/missions/today"
        case .submitMission(let missionId, _):
            return "/api/v1/missions/\(missionId)/submissions"
        case .saveMissionDraft(let userMissionId, _):
            return "/api/v1/missions/\(userMissionId)/drafts"
        case .completeMission(let userMissionId):
            return "/api/v1/missions/\(userMissionId)/status"
        case .restartTodayMission:
            return "/api/v1/missions/today-mission/refresh"
     
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchTodayMission:
            return .get
        case .submitMission, .saveMissionDraft:
            return .post
        case .completeMission, .restartTodayMission:
            return .patch
        }
    }
    
    var task: Task {
        switch self {
        case .fetchTodayMission:
            return .requestPlain
        case .submitMission(_, let data):
            return .requestJSONEncodable(data)
        case .saveMissionDraft(_, let data):
            return .requestJSONEncodable(data)
        case .completeMission:
            return .requestPlain
        case .restartTodayMission:
            return .requestPlain
        }
    }
    
    /*
    var headers: [String : String]? {
        ["Content-Type": "application/json"]
    }
    */
    
    var sampleData: Data {
        switch self {
        case .fetchTodayMission:
            return """
            {
              "isSuccess": true,
              "code": "2000",
              "message": "ok",
              "result": {
                "contents": "오늘은 10분 산책하기",
                "remainingSeconds": 86314,
                "restarted": false
              }
            }
            """.data(using: .utf8)!
        case .submitMission:
            return """
                   {
                     "isSuccess": true,
                     "code": "2000",
                     "message": "ok",
                     "result": {
                       "userMissionId": 1,
                       "remainingSeconds": 85776,
                       "completed": false,
                       "drafted": false
                     }
                   }
                   """.data(using: .utf8)!
            
        case .saveMissionDraft:
            return """
            {
              "isSuccess": true,
              "code": "2000",
              "message": "ok",
              "result": {
                "draftId": 2,
                "updatedAt": "2026-01-13T15:47:13.135703",
                "drafted": true
              }
            }
            """.data(using: .utf8)!
            
        case .completeMission:
            return """
            {
              "isSuccess": true,
              "code": "2000",
              "message": "ok",
              "result": null
            }
            """.data(using: .utf8)!
        case .restartTodayMission:
                   return """
                   {
                     "isSuccess": true,
                     "code": "2000",
                     "message": "Ok",
                     "result": {
                       "contents": "나를 불안하게 만드는 상황에서 ‘내가 원래 잘하던 행동’ 1개 적기",
                       "remainingSeconds": 86399,
                       "restarted": true
                     }
                   }
                   """.data(using: .utf8)!
        }
    }
}
