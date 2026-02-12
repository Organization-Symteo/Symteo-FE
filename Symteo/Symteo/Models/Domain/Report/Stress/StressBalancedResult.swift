//
//  StressResult.swift
//  Symteo
//
//  Created by 박병선 on 1/25/26.
//
import Foundation
import SwiftUI

/// 통제감 / 과부하 결과를 화면에 그리기 위한UI 전용 결과 모델
///
/// 서버에서는 단순 문자열(level)만 내려주기 때문에 ProgressBar, 색상, 설명 문구 등을 한 번에 묶어
/// View에서 바로 사용할 수 있도록 가공한 타입
struct StressBalanceResult {

    /// 프로그레스바 채워지는 비율 (0.0 ~ 1.0)
    let ratio: Double

    /// 화면에 표시할 상태 텍스트 (예: "낮음", "매우 높음")
    let levelText: String

    /// 상태에 대한 설명 문구
    let description: String

    /// 프로그레스바 및 상태 텍스트에 사용될 색상
    let barColor: Color
}

extension StressBalanceResult {

    /// 서버에서 내려온 상황 통제감(controlLevel)문자열을 UI에 필요한 StressBalanceResult로 변환
    ///
    /// - Parameter level: 서버 응답 문자열 ("낮음", "보통", "높음")
    /// - Returns: ProgressBar에 바로 사용할 UI 결과 모델
    static func fromControlLevel(_ level: String) -> StressBalanceResult {
        switch level {

        case "낮음":
            // 통제감이 낮을수록 부정적인 상태 → 붉은 계열
            return StressBalanceResult(
                ratio: 0.25,
                levelText: "낮음",
                description: "상황을 통제하기 어려운 상태입니다.",
                barColor: Color(hex: "#F4574F")
            )

        case "보통":
            return StressBalanceResult(
                ratio: 0.5,
                levelText: "보통",
                description: "상황을 어느 정도 조절하고 있어요.",
                barColor: Color(hex: "#FFAC79")
            )

        case "높음":
            // 통제감이 높을수록 긍정 신호 → 초록 계열
            return StressBalanceResult(
                ratio: 0.75,
                levelText: "높음",
                description: "상황을 잘 통제하고 있어요.",
                barColor: Color(hex: "#63B19B")
            )

        default:
            // 예외 케이스 대비용 기본값
            return StressBalanceResult(
                ratio: 0.5,
                levelText: level,
                description: "",
                barColor: .gray
            )
        }
    }

    /// 서버에서 내려온 일상의 과부하(overloadLevel) 문자열을 UI에 필요한 StressBalanceResult로 변환
    ///
    /// - Parameter level: 서버 응답 문자열 ("매우 높음", "높음", "낮음")
    /// - Returns: ProgressBar에 바로 사용할 UI 결과 모델
    static func fromOverloadLevel(_ level: String) -> StressBalanceResult {
        switch level {

        case "매우 높음":
            // 과부하가 높을수록 위험 신호 → 붉은 계열
            return StressBalanceResult(
                ratio: 0.9,
                levelText: "매우 높음",
                description: "일상의 부담이 극도로 큰 상태입니다.",
                barColor: Color(hex: "#F4574F")
            )

        case "높음":
            return StressBalanceResult(
                ratio: 0.7,
                levelText: "높음",
                description: "업무나 책임이 과도하게 느껴질 수 있어요.",
                barColor: Color(hex: "#FFAC79")
            )

        case "낮음":
            // 과부하가 낮을수록 긍정 신호 → 초록 계열
            return StressBalanceResult(
                ratio: 0.3,
                levelText: "낮음",
                description: "일상의 부담이 비교적 적은 상태입니다.",
                barColor: Color(hex: "#63B19B")
            )

        default:
            // 예외 케이스 대비용 기본값
            return StressBalanceResult(
                ratio: 0.5,
                levelText: level,
                description: "",
                barColor: .gray
            )
        }
    }
}
