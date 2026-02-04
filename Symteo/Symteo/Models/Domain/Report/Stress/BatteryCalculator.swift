//
//  BatteryCalculator.swift
//  Symteo
//
//  Created by 박병선 on 1/22/26.
//
import Foundation

struct BatteryCalculator {

    static func calculate(pssScore: Int, burnoutScore: Int) -> BatteryResult {

        let maxScore = 40 + 40   // 실제 max 기준
        let current = pssScore + burnoutScore

        let percent = max(
            0,
            min(
                100,
                100 - Int(
                    round(Double(current) / Double(maxScore) * 100)
                )
            )
        )

        let status = BatteryStatus.from(percent: percent)

        return BatteryResult(
            percent: percent,
            status: status
        )
    }
}
