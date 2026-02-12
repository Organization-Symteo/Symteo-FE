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
    
    // 사용자 이름 (헤더 표시용)
    @Published var userName: String = "따오기" // 로그인 정보에서 주입 예정
    
    // 하단 프로모션 배너 현재 페이지
    @Published var currentPromoPage: Int = 0
    
    @Published var pendingReportType: ReportType? = nil
    
    
    // 메인 리포트 목록 (고정 데이터)
    let reportList: [ReportItem] = [
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
   
    // 하단 프로모션 영역에 사용되는 목록
    let promotionList: [PromotionItem] = [
        PromotionItem(imageName: "promotion_anxiety", type: .anxiety),
        PromotionItem(imageName: "promotion_stress", type: .stress),
        PromotionItem(imageName: "promotion_attachment", type: .attachment)
    ]

    // 리포트 없음 팝업 표시 여부
    @Published var isShowingNoReportPopUp: Bool = false
    
    // 공통 토스트 메시지
    @Published var toast: CustomToast? = nil

    // 각 리포트의 존재 여부 상태
    @Published var anxietyReportStatus: ReportStatus = .none
    @Published var stressReportStatus: ReportStatus = .none
    @Published var attachmentReportStatus: ReportStatus = .none

    // DI 컨테이너
    let container: DIContainer

    init(container: DIContainer) {
        self.container = container
    }

    // 우울·불안 리포트 존재 여부 (View 전용)
    var hasAnxietyReport: Bool {
        if case .available = anxietyReportStatus { return true }
        return false
    }

    // 스트레스 리포트 존재 여부 (View 전용)
    var hasStressReport: Bool {
        if case .available = stressReportStatus { return true }
        return false
    }

    // 애착 리포트 존재 여부 (View 전용)
    var hasAttachmentReport: Bool {
        if case .available = attachmentReportStatus { return true }
        return false
    }
}
