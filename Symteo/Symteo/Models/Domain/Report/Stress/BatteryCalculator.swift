//
//  BatteryCalculator.swift
//  Symteo
//
//  Created by 박병선 on 1/22/26.
//
import Foundation

/// 스트레스(PSS) 점수와 번아웃 점수를 기반으로
/// 마음 배터리 결과를 계산하는 유틸리티 타입
///
struct BatteryCalculator {

    /// 스트레스(PSS) 점수와 번아웃 점수를 받아 마음 배터리 결과를 계산한다
    ///
    /// - Parameters:
    ///   - pssScore: 스트레스 검사 점수 (예: 0 ~ 40)
    ///   - burnoutScore: 번아웃 점수 (예: 0 ~ 40)
    ///
    /// - Returns:
    ///   - BatteryResult:
    ///     계산된 배터리 퍼센트와 그에 대응하는 BatteryStatus
    static func calculate(pssScore: Int, burnoutScore: Int) -> BatteryResult {

        /// 스트레스 + 번아웃 점수의 최대 합
        /// 현재 기획 기준에서는 각각 40점 만점
        let maxScore = 40 + 40

        /// 현재 사용자가 받은 총 부담 점수
        let current = pssScore + burnoutScore

        /// 배터리 퍼센트 계산 로직
        ///
        /// 1. (현재 점수 / 최대 점수) * 100 → 소모 비율
        /// 2. 100 - 소모 비율 → 남은 배터리 퍼센트
        /// 3. 0 ~ 100 범위로 강제 클램프
        let percent = max(
            0,
            min(
                100,
                100 - Int(
                    round(Double(current) / Double(maxScore) * 100)
                )
            )
        )

        /// 퍼센트 값에 따라 배터리 상태(enum) 결정
        let status = BatteryStatus.from(percent: percent)

        /// UI에서 바로 사용할 수 있는 BatteryResult 반환
        return BatteryResult(
            percent: percent,
            status: status
        )
    }
}
