//
//  SituationalControlLevel.swift
//  Symteo
//
//  Created by 박병선 on 1/25/26.
//
import SwiftUI

enum SituationalControlLevel {
    case veryLow
    case low
    case normal
    case high
}

extension SituationalControlLevel {

    static func from(score: Int) -> Self {
        switch score {
        case 0...4: return .veryLow
        case 5...8: return .low
        case 9...12: return .normal
        default: return .high
        }
    }
/*
 var title: String { ... }
     var description: String { ... }
     var barColor: Color { ... }
 */
    var title: String {
        switch self {
        case .veryLow: return "매우 낮음"
        case .low: return "낮음"
        case .normal: return "보통"
        case .high: return "높음"
        }
    }

    var barColor: Color {
        switch self {
        case .veryLow: return Color(hex: "#F4574F")
        case .low: return Color(hex: "#FFAC79")
        case .normal: return Color(hex: "#FFE8A9")
        case .high: return Color(hex: "#63B19B")
        }
    }

    var description: String {
        switch self {
        case .veryLow:
            return "삶을 스스로 조절하기 어렵게 느껴집니다." //삶을 스스로 조절하기 어렵게 느껴집니다.
        case .low:
            return "상황에 흔들리는 일이 잦은 상태입니다." //
        case .normal:
            return "대체로 관리되고 있으나 부담이 있습니다."
        case .high:
            return "상황을 안정적으로 통제하고 있습니다."
        }
    }
}
