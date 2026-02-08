//
//  ReportRouter.swift
//  Symteo
//
//  Created by 박병선 on 2/8/26.
//
import Foundation
import Moya
/*
enum ReportRouter {
    /// 우울&불안 리포트 생성
    case createDepressionAnxietyReport(diagnoseId: Int)
    
    /// 우울·불안 리포트 상세 조회
    case getDepressionAnxietyReport(reportId: Int)
    
    /// 스트레스 리포트 생성
    case creatStressReport(diagnoseId: Int)
    
    /// 스트레스 리포트 조회
    case getStressReport(reportId: Int)
    
    /// 애착 리포트 생성
    case creatAttachmentReport(diagnoseId: Int)
    
    /// 애착 리포트 조회
    case getAttachmentReport(reportId: Int)
    
}

extension ReportRouter: TargetType {
    
    var baseURL: URL {
        return URL(string: Config.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .createDepressionAnxietyReport(let diagnoseId):
            return "/api/v1/reports/depression-anxiety/\(diagnoseId)"
            
        case .getDepressionAnxietyReport(let reportId):
            return "/api/v1/reports/\(reportId)/depression-anxiety/\(reportId)"
            
        case .creatStressReport(let diagnoseId):
            return "/api/v1/reports/stress-burnout/\(diagnoseId)"
            
        case .getStressReport(let reportId):
            return "/api/v1/reports/\(reportId)/stress-burnout/\(reportId)"
            
        case .creatAttachmentReport(let diagnoseId):
            return "/api/v1/reports/attachment/\(diagnoseId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createDepressionAnxietyReport, .creatStressReport, .creatAttachmentReport:
            return .post
            
        case .getDepressionAnxietyReport, .getStressReport, .getAttachmentReport:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .createDepressionAnxietyReport, .creatStressReport, .creatAttachmentReport:
            return .requestPlain
        case .getDepressionAnxietyReport, .getStressReport, .getAttachmentReport:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        ["Content-Type": "application/json"]
    }
    
    
    var sampleData: Data {
        let json: String
        
        switch self {
            
        case .createDepressionAnxietyReport:
            json = """
            {
              "isSuccess": true,
              "code": "2000",
              "message": "OK",
              "result": {
                "reportId": 14,
                "testType": "DEPRESSION_ANXIETY_COMPLEX",
                "createdAt": "2026-01-28T07:26:52.065656"
              }
            }
            """
            
        case .getDepressionAnxietyReport:
            json = """
            {
              "isSuccess": true,
              "code": "2000",
              "message": "Ok",
              "result": {
                "reportId": 28,
                "testType": "DEPRESSION_ANXIETY_COMPLEX",
                "summary": {
                  "averageScore": 14.0,
                  "statusLabel": "주의",
                  "statusColor": "#FFAC79"
                },
                "phq9": {
                  "totalScore": 13,
                  "needleDeg": 86.66666666666666,
                  "clusters": [
                    {
                      "name": "핵심 증상",
                      "scoreRatio": 0.3333333333333333,
                      "color": "#FFE8A9"
                    },
                    {
                      "name": "신체 증상",
                      "scoreRatio": 0.6666666666666666,
                      "color": "#FFAC79"
                    },
                    {
                      "name": "심리 증상",
                      "scoreRatio": 0.5555555555555556,
                      "color": "#FFAC79"
                    }
                  ]
                },
                "gad7": {
                  "totalScore": 15,
                  "needleDeg": 128.57142857142858,
                  "clusters": [
                    {
                      "name": "정서적 불안",
                      "scoreRatio": 0.7777777777777778,
                      "color": "#F4574F"
                    },
                    {
                      "name": "신체적 긴장",
                      "scoreRatio": 0.6666666666666666,
                      "color": "#FFAC79"
                    }
                  ]
                },
                "aiInsightCards": [
                  { "id": "sleep_issue", "title": "수면 장애 심각" },
                  { "id": "focus_issue", "title": "집중력 저하" },
                  { "id": "worry_issue", "title": "지속적인 걱정" }
                ],
                "depressionAiContent": "우울 AI 분석 내용",
                "anxietyAiContent": "불안 AI 분석 내용",
                "emergencyFlag": true,
                "createdAt": "2026-01-28T15:00:42"
              }
            }
            """
            
        case .creatStressReport:
            json = """
               {
                 "isSuccess": true,
                 "code": "2000",
                 "message": "Ok",
                 "result": {
                   "reportId": 20,
                   "testType": "STRESS_BURNOUT_COMPLEX",
                   "createdAt": "2026-01-28T13:29:15.987073"
                 }
               }
               """
        case .getStressReport:
            json = """
               {
                 "isSuccess": true,
                 "code": "2000",
                 "message": "Ok",
                 "result": {
                   "reportId": 25,
                   "testType": "STRESS_BURNOUT_COMPLEX",
                   "batteryPercent": 65,
                   "batteryColor": "#FAD000",
                   "batteryGuide": "조금씩 지쳐가고 있어요. 나를 돌봐주세요.",
                   "stress": {
                     "pssScore": 37,
                     "stressLevel": "매우 위험",
                     "controlLevel": "낮음",
                     "overloadLevel": "매우 높음"
                   },
                   "burnout": {
                     "exhaustionLevel": "낮음",
                     "cynicismLevel": "낮음",
                     "inefficacyLevel": "낮음",
                     "totalLevel": "정상"
                   },
                   "aiInsights": [
                     "내가 할 수 있는 일은 없는데 해야 할 일만 쌓여가는, 가장 고통스러운 지점입니다."
                   ],
                   "aiFullContent": "데모유저님의 현재 스트레스 온도는 '매우 위험' 상태입니다.",
                   "createdAt": "2026-01-28T13:43:29"
                 }
               }
               """
            
        case .creatAttachmentReport:
            json = """
               {
                 "isSuccess": true,
                 "code": "2000",
                 "message": "Ok",
                 "result": {
                   "reportId": 29,
                   "testType": "ATTACHMENT_TEST",
                   "createdAt": "2026-01-28T16:39:31.465001"
                 }
               }
               """
        }
        
        
        return Data(json.utf8)
    }
}
*/
