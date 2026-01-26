//
//  AttachmentViewModel.swift
//  Symteo
//
//  Created by 박병선 on 1/19/26.
//
import SwiftUI
import Foundation

final class AttachmentReportViewModel: ObservableObject {

    // MARK: - Raw Scores (서버에서 받는 값)
    let anxietyScore: Int      // 예: 75
    let avoidanceScore: Int    // 예: 30

    // MARK: - Init
    init(
        anxietyScore: Int = 75,
        avoidanceScore: Int = 20
    ) {
        self.anxietyScore = anxietyScore
        self.avoidanceScore = avoidanceScore
        self.attachmentType = .anxious
    }

    // MARK: - Results for View

    var anxietyResult: AttachmentBarResult {
        makeResult(
            score: anxietyScore,
            metric: .anxiety,
            maxScore: 100
        )
    }

    var avoidanceResult: AttachmentBarResult {
        makeResult(
            score: avoidanceScore,
            metric: .avoidance,
            maxScore: 100
        )
    }

    // MARK: - Private Helper

    private func makeResult(
        score: Int,
        metric: AttachmentMetricType,
        maxScore: Int
    ) -> AttachmentBarResult {

        let ratio = Double(score) / Double(maxScore)
        let level = AttachmentBarLevel.from(ratio: ratio)

        return AttachmentBarResult(
            score: score,          
            ratio: ratio,
            level: level,
            metric: metric
        )
    }
    
    //MARK: -애착유형에 대한 description
    let attachmentType: AttachmentType
    
    // MARK: - 애착유형 설명 더미데이터
    var description: String {
           // TODO: API 연결 전 더미
           switch attachmentType {
           case .anxious:
               return "따오기님의 애착유형은 ‘불안형’입니다. 따오기님의 애착유형은 ‘불안형’입니다. 따오기님의 애착유형은 ‘불안형’입니다. ..."
           case .secure:
               return "따오기님의 애착유형은 ‘안정형’입니다. 따오기님의 애착유형은 ‘안정형’입니다. 따오기님의 애착유형은 ‘안정형’입니다. ..."
           case .fearfulAvoidant:
               return "따오기님의 애착유형은 ‘공포 회피형’입니다. 따오기님의 애착유형은 ‘공포 회피형’입니다. 따오기님의 애착유형은 ‘공포 회피형’입니다. ..."
           case .dismissiveAvoidant:
               return "따오기님의 애착유형은 ‘거부 회피형’입니다. 따오기님의 애착유형은 ‘거부 회피형’입니다. 따오기님의 애착유형은 ‘거부 회피형’입니다. ..."
           }
       }
}
