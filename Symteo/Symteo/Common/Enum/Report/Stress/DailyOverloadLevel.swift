//
//  DailyOverloadLevel.swift
//  Symteo
//
//  Created by 박병선 on 1/25/26.
//
import SwiftUI

// StressResultCard 
enum DailyOverloadLevel {
    case veryLow
    case normal
    case high
    case veryHigh
}

extension DailyOverloadLevel {

    static func from(score: Int) -> Self {
        switch score {
        case 0...6: return .veryLow
        case 7...12: return .normal
        case 13...18: return .high
        default: return .veryHigh
        }
    }

    var title: String {
        switch self {
        case .veryLow: return "매우 낮음"
        case .normal: return "보통"
        case .high: return "높음"
        case .veryHigh: return "매우 높음"
        }
    }

    var barColor: Color {
        switch self {
        case .veryLow: return Color(hex: "#63B19B")
        case .normal: return Color(hex: "#FFE8A9")
        case .high: return Color(hex: "#FFAC79")
        case .veryHigh: return Color(hex: "#F4574F")
        }
    }

    var description: String {
        switch self {
        case .veryLow:
            return "일상이 비교적 여유로운 상태입니다."
        case .normal:
            return "일상에 부담이 조금씩 쌓이고 있습니다."
        case .high:
            return "피로와 압박이 뚜렷하게 느껴집니다."
        case .veryHigh:
            return "과부하 상태로 휴식이 필요합니다."
        }
    }
}
