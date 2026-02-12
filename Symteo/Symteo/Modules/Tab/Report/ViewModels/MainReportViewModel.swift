//
//  Untitled.swift
//  Symteo
//
//  Created by 박병선 on 1/18/26.
//
import SwiftUI
import Foundation
import Combine
import Moya

@MainActor
final class MainReportViewModel: ObservableObject {
    // 메인 리포트 화면 전용 ViewModel (UI 상태 + 리포트 존재 여부 관리)
    
    @Published var userName: String = "따오기"
    // 헤더에 표시할 사용자 이름 (추후 로그인 정보로 교체 예정)
    
    @Published var currentPromoPage: Int = 0
    // 하단 프로모션 배너의 현재 페이지 인덱스
    
    @Published var pendingReportType: ReportType? = nil
    // 팝업 확인 후 이동해야 할 리포트 타입을 임시 저장
    
    let reportList: [ReportItem] = [
        // 메인에 표시되는 리포트 목록 (고정 UI 데이터)
        ReportItem(
            title: "우울·불안 리포트",
            description: "내 마음속에 숨은 비구름을 확인해봐요",
            fullImageName: "anxiety_report",
            type: .anxiety
        ),
        ReportItem(
            title: "스트레스 리포트",
            description: "어깨에 짊어진 무거운 짐을 내려놓을 시간",
            fullImageName: "stress_report",
            type: .stress
        ),
        ReportItem(
            title: "성향 리포트",
            description: "나의 애착유형과 성향을 알아가는 시간",
            fullImageName: "attachment_report",
            type: .attachment
        )
    ]
   
    let promotionList: [PromotionItem] = [
        // 하단 프로모션 배너에 사용되는 아이템 목록
        PromotionItem(imageName: "promotion_anxiety", type: .anxiety),
        PromotionItem(imageName: "promotion_stress", type: .stress),
        PromotionItem(imageName: "promotion_attachment", type: .attachment)
    ]

    @Published var isShowingNoReportPopUp: Bool = false
    // 리포트가 없을 때 표시되는 팝업 여부
    
    @Published var toast: CustomToast? = nil
    // 공통 에러/알림 토스트 메시지
    
    @Published var anxietyReportStatus: ReportStatus = .none
    // 우울·불안 리포트 존재 상태 (none / available 등)
    
    @Published var stressReportStatus: ReportStatus = .none
    // 스트레스 리포트 존재 상태
    
    @Published var attachmentReportStatus: ReportStatus = .none
    // 애착 리포트 존재 상태

    let container: DIContainer
    // DIContainer (서비스 및 라우팅 접근용)

    init(container: DIContainer) {
        self.container = container
        // DIContainer 주입
    }

    var hasAnxietyReport: Bool {
        // View에서 사용하기 위한 우울·불안 리포트 존재 여부 계산 프로퍼티
        if case .available = anxietyReportStatus { return true }
        return false
    }

    var hasStressReport: Bool {
        // View에서 사용하기 위한 스트레스 리포트 존재 여부 계산 프로퍼티
        if case .available = stressReportStatus { return true }
        return false
    }

    var hasAttachmentReport: Bool {
        // View에서 사용하기 위한 애착 리포트 존재 여부 계산 프로퍼티
        if case .available = attachmentReportStatus { return true }
        return false
    }
    
    // MARK: - Local 리포트 상태 조회
    func fetchReportStatusFromLocal() {
        //  우울·불안 리포트 확인
        if let reportId = UserDefaults.standard.object(
            forKey: "reportId_DEPRESSION_ANXIETY_COMPLEX"
        ) as? Int {
            anxietyReportStatus = .available(reportId)
        } else {
            anxietyReportStatus = .none
        }

        // 스트레스 리포트 확인
        if let reportId = UserDefaults.standard.object(
            forKey: "reportId_STRESS_BURNOUT_COMPLEX"
        ) as? Int {
            stressReportStatus = .available(reportId)
        } else {
            stressReportStatus = .none
        }

        //  애착 리포트 확인
        if let reportId = UserDefaults.standard.object(
            forKey: "reportId_ATTACHMENT_TEST"
        ) as? Int {
            attachmentReportStatus = .available(reportId)
        } else {
            attachmentReportStatus = .none
        }
    }
}
