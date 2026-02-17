//
//  ReportRouter.swift
//  Symteo
//
//  Created by 박병선 on 2/8/26.
//
import Foundation
import Moya
import Alamofire

enum ReportRouter {

    // MARK: - 리포트 생성
    /// 우울&불안 리포트 생성
    case createDepressionAnxietyReport(diagnoseId: Int)
    
    /// 스트레스 리포트 생성
    case createStressReport(diagnoseId: Int)
    
    /// 애착 리포트 생성
    case createAttachmentReport(diagnoseId: Int)
    
    
    // MARK: - 리포트 조회
    /// 우울·불안 리포트  조회
    case getDepressionAnxietyReport(reportId: Int)
    
    /// 스트레스 리포트 조회
    case getStressReport(reportId: Int)
    
    /// 애착 리포트 조회
    case getAttachmentReport(reportId: Int)
    
}

extension ReportRouter: TargetType {
    
    var baseURL: URL {
        return URL(string: Config.baseUrl)!
    }
    
    var path: String {
        switch self {
            /// 생성
        case .createDepressionAnxietyReport(let diagnoseId):
            return "/api/v1/reports/diagnose/\(diagnoseId)/depression-anxiety"
        case .createStressReport(let diagnoseId):
            return "/api/v1/reports/diagnose/\(diagnoseId)/stress-burnout"
        case .createAttachmentReport(let diagnoseId):
            return "/api/v1/reports/diagnose/\(diagnoseId)/attachment"
            
            
            /// 조회
        case .getDepressionAnxietyReport(let reportId):
            return "/api/v1/reports/depression-anxiety/\(reportId)"

        case .getStressReport(let reportId):
            return "/api/v1/reports/stress-burnout/\(reportId)"

        case .getAttachmentReport(let reportId):
            return "/api/v1/reports/attachment/\(reportId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createDepressionAnxietyReport, .createStressReport, .createAttachmentReport:
            return .post
            
        case .getDepressionAnxietyReport, .getStressReport, .getAttachmentReport:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .createDepressionAnxietyReport, .createStressReport, .createAttachmentReport:
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
                    { "name": "핵심 증상", "scoreRatio": 0.3333333333333333, "color": "#FFE8A9" },
                    { "name": "신체 증상", "scoreRatio": 0.6666666666666666, "color": "#FFAC79" },
                    { "name": "심리 증상", "scoreRatio": 0.5555555555555556, "color": "#FFAC79" }
                  ]
                },
                "gad7": {
                  "totalScore": 15,
                  "needleDeg": 128.57142857142858,
                  "clusters": [
                    { "name": "정서적 불안", "scoreRatio": 0.7777777777777778, "color": "#F4574F" },
                    { "name": "신체적 긴장", "scoreRatio": 0.6666666666666666, "color": "#FFAC79" }
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

        case .createStressReport:
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

        case .createAttachmentReport:
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

        case .getAttachmentReport:
            json = """
            {
              "isSuccess": true,
              "code": "2000",
              "message": "Ok",
              "result": {
                "reportId": 31,
                "userName": "데모유저",
                "attachmentType": "안정형",
                "anxiety": {
                  "score": 1.0,
                  "percentage": 0,
                  "stateLabel": "매우 낮음",
                  "color": "#63B19B",
                  "stateComment": "정서적으로 안정적이고 신뢰감이 높아요."
                },
                "avoidance": {
                  "score": 1.0,
                  "percentage": 0,
                  "stateLabel": "매우 낮음",
                  "color": "#63B19B",
                  "stateComment": "친밀한 관계 형성에 비교적 적극적이에요."
                },
                "stressPoints": [
                  { "title": "갑작스러운 관계의 단절이나 변화", "description": "예기치 못한 이별이나 소통의 부재는 안정형에게도 큰 충격입니다." }
                ],
                "strengthPoints": [
                  { "title": "타인과 건강한 경계를 유지하는 능력", "description": "건강한 거리 조절 능력을 가지고 있습니다." }
                ],
                "aiFullContent": "AI 종합 분석 내용",
                "actionGuideSentence": "지금처럼 솔직한 소통을 유지해 보세요.",
                "createdAt": "2026-01-28T16:52:50"
              }
            }
            """
        }

        return Data(json.utf8)
    }
}

