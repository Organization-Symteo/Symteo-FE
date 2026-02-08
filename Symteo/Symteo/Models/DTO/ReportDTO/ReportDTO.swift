//
//  ReportDTO.swift
//  Symteo
//
//  Created by 박병선 on 2/8/26.
//
import Foundation

// MARK: -우울/불안 리포트 생성 DTO
struct DepressionAnxietyReportResult: Decodable {
    let reportId: Int
    let testType: String
    let createdAt: String
}

// MARK: - 우울/불안 리포트 조회 DTO
struct DepressionAnxietyReportDetail: Decodable {
    let reportId: Int                    // 리포트 고유 ID
    let testType: String                 // 검사 유형 (ex. DEPRESSION_ANXIETY_COMPLEX)
    let summary: ReportSummary           // 리포트 요약 정보 (평균 점수, 상태 등)
    let phq9: ScaleResult                // 우울 척도(PHQ-9) 결과
    let gad7: ScaleResult                // 불안 척도(GAD-7) 결과
    let aiInsightCards: [AIInsightCard]  // AI가 분석한 주요 인사이트 카드 목록
    let depressionAiContent: String      // 우울 상태에 대한 AI 서술 분석
    let anxietyAiContent: String         // 불안 상태에 대한 AI 서술 분석
    let emergencyFlag: Bool              // 긴급 대응 필요 여부 (true면 위기 UI 노출)
    let createdAt: String                // 리포트 생성 시각 (ISO 8601 문자열)
}

struct ReportSummary: Decodable {
    let averageScore: Double             // PHQ/GAD 종합 평균 점수
    let statusLabel: String              // 상태 라벨 (정상 / 주의 / 위험 등)
    let statusColor: String              // 상태 색상 HEX 코드 (UI 컬러용)
}

struct ScaleResult: Decodable {
    let totalScore: Int                  // 척도 총점
    let needleDeg: Double                // 게이지 바늘 각도 (원형 그래프용)
    let clusters: [SymptomCluster]       // 증상 영역별 클러스터 목록
}

struct SymptomCluster: Decodable {
    let name: String                     // 증상 클러스터 이름 (ex. 핵심 증상)
    let scoreRatio: Double               // 전체 대비 점수 비율 (0.0 ~ 1.0)
    let color: String                    // 클러스터 색상 HEX 코드
}

struct AIInsightCard: Decodable {
    let id: String                       // 인사이트 식별자 (아이콘/이미지 매핑용)
    let title: String                    // 카드에 표시될 제목 텍스트
}


// MARK: - 스트레스 리포트 생성 DTO
struct StressReportResult: Decodable {
    let reportId: Int        // 생성된 리포트 ID
    let testType: String     // 검사 유형 (STRESS_BURNOUT_COMPLEX)
    let createdAt: String   // 리포트 생성 시각
}

// MARK: - 스트레스 리포트 조회 DTO
struct StressReportDetail: Decodable {
    let reportId: Int                 // 리포트 ID
    let testType: String              // 검사 유형 (STRESS_BURNOUT_COMPLEX)
    let batteryPercent: Int           // 마음 에너지 배터리 퍼센트
    let batteryColor: String          // 배터리 색상 HEX 코드
    let batteryGuide: String          // 배터리 상태 안내 문구
    let stress: StressResult          // 스트레스(PSS) 결과
    let burnout: BurnoutResult        // 번아웃 결과
    let aiInsights: [String]          // AI 핵심 인사이트 문장 배열
    let aiFullContent: String         // AI 전체 분석 텍스트
    let createdAt: String             // 리포트 생성 시각
}

struct StressResult: Decodable {
    let pssScore: Int                 // PSS 점수
    let stressLevel: String           // 스트레스 수준 (정상 / 위험 등)
    let controlLevel: String          // 통제감 수준
    let overloadLevel: String         // 과부하 수준
}

struct BurnoutResult: Decodable {
    let exhaustionLevel: String       // 소진 수준
    let cynicismLevel: String         // 냉소 수준
    let inefficacyLevel: String       // 비효율감 수준
    let totalLevel: String            // 종합 번아웃 수준
}

// MARK: - 애착검사 리포트 생성 DTO
struct AttachmentReportCreateResult: Decodable {
    let reportId: Int        // 생성된 리포트 ID
    let testType: String     // 검사 유형 (ATTACHMENT_TEST)
    let createdAt: String   // 리포트 생성 시각
}
