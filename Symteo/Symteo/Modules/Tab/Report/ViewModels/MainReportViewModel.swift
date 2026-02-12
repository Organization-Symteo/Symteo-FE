//
//  Untitled.swift
//  Symteo
//
//  Created by 박병선 on 1/18/26.
//
import SwiftUI
import Combine


class MainReportViewModel: ObservableObject {
    
    // 상태 변수
    @Published var userName: String = "따오기"
    @Published var currentPromoPage: Int = 0 // 현재 스와이프 페이지
    @Published var isShowingNoReportPopUp = false // 팝업 노출 상태

    // 임시 더미
    let hasAnxietyReport = true
    let hasStressReport = true
    let hasAttachmentReport = true
    
    // 리포트 목록 데이터
    let reportList: [ReportItem] = [
        ReportItem(title: "우울·불안 리포트", description: "내 마음속에 숨은 비구름을 확인해봐요", fullImageName: "anxiety_report", type: .anxiety),
        ReportItem(title: "스트레스 리포트", description: "어깨에 짊어진 무거운 짐을 내려놓을 시간", fullImageName: "stress_report", type: .stress),
        ReportItem(title: "성향 리포트", description: "나의 애착유형과 성향을 알아가는 시간", fullImageName: "attachment_report", type: .attachment)
    ]
   
    //ReportView -> PromotionSection 목록
    let promotionList: [PromotionItem] = [
        PromotionItem(imageName: "promotion_anxiety", type: .anxiety),
        PromotionItem(imageName: "promotion_stress", type: .stress),
        PromotionItem(imageName: "promotion_attachment", type: .attachment)
        ]
    
    // 리포트 클릭 시 로직
    func handleReportClick(item: ReportItem) {
        // 데이터 없는 경우 팝업을 띄움
        isShowingNoReportPopUp = true
    }

    
}
