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
    case startMission(missionId: Int, data: MissionStartRequest) // 미션 시작
    case saveMissionDraft(userMissionId: Int, data: MissionDraftRequest) // 미션 텍스트 제출
    case completeMission(userMissionId: Int) // 미션 완료
    case restartTodayMission // 미션 새로고침
}
extension MissionRouter: APITargetType {
    var baseURL: URL {
        return URL(string: "\(Config.baseUrl)")!
    }
    
    var path: String {
        switch self {
        case .fetchTodayMission:
            return "/api/v1/missions/today"
        case .startMission(let missionId, _):
            return "/api/v1/missions/{missionId}/start"
        case .saveMissionDraft(let userMissionId, _):
            return "/api/v1/missions/\(userMissionId)/draft"
        case .completeMission(let userMissionId):
            return "/api/v1/missions/\(userMissionId)/completed"
        case .restartTodayMission:
            return "/api/v1/missions/today-mission/restart"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchTodayMission:
            return .get
        case .startMission, .saveMissionDraft, .completeMission, .restartTodayMission:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .fetchTodayMission:
            return .requestPlain
        case .startMission(_, let data):
            return .requestJSONEncodable(data)
        case .saveMissionDraft(_, let data):
            return .requestJSONEncodable(data)
        case .completeMission:
            return .requestPlain
        case .restartTodayMission:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        ["Content-Type": "application/json"]
    }
    
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
        case .startMission:
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
