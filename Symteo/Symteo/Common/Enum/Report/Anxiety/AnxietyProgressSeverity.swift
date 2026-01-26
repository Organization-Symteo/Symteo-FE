//
//  PHQSevereity.swift
//  Symteo
//
//  Created by 박병선 on 1/21/26.
//
//  우울과 불안 주요 증상 클러스터에서 점수 결과에 따라 달라지는 ProgressView를 구현하기 위한 Enum입니다.
import SwiftUI

enum AnxietyProgressSeverity {
    case low
    case mediumLow
    case mediumHigh
    case high

    static func from(ratio: Double) -> AnxietyProgressSeverity {
        switch ratio { 
        case 0.0...0.25:
            return .low
        case 0.26...0.50:
            return .mediumLow
        case 0.51...0.75:
            return .mediumHigh
        default:
            return .high
        }
    }

    var progressColor: Color {
        switch self {
                case .low:
                    return Color(hex: "#63B19B")   // 초록
                case .mediumLow:
                    return Color(hex: "#FFE8A9")   // 노랑
                case .mediumHigh:
                    return Color(hex: "#FFAC79")   // 주황
                case .high:
                    return Color(hex: "#F4574F")   // 빨강
                }
            }
}
