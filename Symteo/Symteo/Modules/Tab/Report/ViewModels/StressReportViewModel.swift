//
//  StressViewModel.swift
//  Symteo
//
//  Created by 박병선 on 1/19/26.
//
import Foundation
import SwiftUI

final class StressReportViewModel: ObservableObject {
    
    // MARK: - Raw Scores (서버에서 받는 값)
    let stressScore: Int
    let situationalControlScore: Int
    let dailyOverloadScore: Int
    
    // MARK: - Init
    init(
        stressScore: Int,
        situationalControlScore: Int,
        dailyOverloadScore: Int
    ) {
        self.stressScore = stressScore
        self.situationalControlScore = situationalControlScore
        self.dailyOverloadScore = dailyOverloadScore
    }
    
    
    // MARK: - 하드코딩된 더미 데이터(번아웃 결과 섹션)

    let emotionalExhaustion = BurnoutFactorResult(
        title: "정서적 소진",
        levelText: "매우 심각",
        description: "마음의 에너지가 거의 소진된 상태예요.",
        ratio: 0.85,
        color: Color(hex: "#F4574F")
    )

    let accomplishmentLoss = BurnoutFactorResult(
        title: "성취감 저하",
        levelText: "심각",
        description: "내가 잘하고 있는지 모르겠어요.",
        ratio: 0.65,
        color: Color(hex: "#FFAC79")
    )

    let depersonalization = BurnoutFactorResult(
        title: "비인격화",
        levelText: "매우 낮음",
        description: "사람들과 거리를 두고 싶어요.",
        ratio: 0.25,
        color: Color(hex: "#63B19B")
    )
}
    // 스트레스 온도계용
extension StressReportViewModel {

    var stressLevel: StressLevel {
        StressLevel.from(score: stressScore)
    }

    var stressRatio: Double {
        Double(stressScore) / 40.0
    }
}

// MARK: - Situational Control
extension StressReportViewModel {

    var situationalControlResult: StressBalanceResult {
        let level = SituationalControlLevel.from(score: situationalControlScore)
        let ratio = Double(situationalControlScore) / 16.0

        return StressBalanceResult(
            ratio: ratio,
            levelText: level.title,
            description: level.description,
            barColor: level.barColor
        )
    }
}

// MARK: - Daily Overload
extension StressReportViewModel {

    var dailyOverloadResult: StressBalanceResult {
        let level = DailyOverloadLevel.from(score: dailyOverloadScore)
        let ratio = Double(dailyOverloadScore) / 24.0

        return StressBalanceResult(
            ratio: ratio,
            levelText: level.title,
            description: level.description,
            barColor: level.barColor
        )
    }
}

/// 프리뷰용 더미데이터
extension StressReportViewModel {

    static let preview = StressReportViewModel(
        stressScore: 32,
        situationalControlScore: 3,
        dailyOverloadScore: 22
    )
}

extension StressReportViewModel {

    var stressDescriptionText: String {
        Array(repeating:
            "따오기님의 현재 스트레스 상태는 ‘중증도’입니다.",
              count: 5
        ).joined(separator: " ")
    }
}
