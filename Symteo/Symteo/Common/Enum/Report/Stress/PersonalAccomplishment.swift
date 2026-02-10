//
//  PersonalAccomplishment.swift
//  Symteo
//
//  Created by 박병선 on 1/25/26.
//

import SwiftUI

//성취감저하의 단계 를 나타내는 Enum입니다.
enum PersonalAccomplishment: String {
    case veryLow = "매우 낮음"
    case low = "낮음"
    case normal = "보통"
    case severe = "높음"
    case verySevere = "매우 심각"
}

extension PersonalAccomplishment {
    
    static func from(text: String) -> PersonalAccomplishment {
           switch text {
           case "매우 낮음": return .veryLow
           case "낮음": return .low
           case "보통": return .normal
           case "높음": return .severe
           case "매우 높음": return .verySevere
           default: return .normal
           }
       }
    
    var ratio: Double {
        switch self {
        case .veryLow: return 0.15
        case .low: return 0.30
        case .normal: return 0.50
        case .severe: return 0.70
        case .verySevere: return 0.85
        }
    }

    var title: String { rawValue }

    var titleColor: Color {
        switch self {
        case .veryLow: return Color(hex: "#3B8470")
        case .low: return Color(hex: "#429A8E")
        case .normal: return Color(hex: "#E96045")
        case .severe: return Color(hex: "#E96045")
        case .verySevere: return Color(hex: "#ED3F36")
        }
    }

    var progressColor: Color {
        switch self {
        case .veryLow: return Color(hex: "#63B19B")
        case .low: return Color(hex: "#D9D9D9")
        case .normal: return Color(hex: "#FFE8A9")
        case .severe: return Color(hex: "#FFAC79")
        case .verySevere: return Color(hex: "#F4574F")
        }
    }

    var description: String {
        switch self {
        case .veryLow:
            return "일에서 충분한 보람을 느껴요."
        case .low:
            return "역할을 무난히 해내고 있어요."
        case .normal:
            return "보람과 자신감이 줄어들고 있어요."
        case .severe:
            return "스스로에 대한 평가가 낮아져요."
        case .verySevere:
            return "유능하다는 느낌이 거의 없어요."
        }
    }
}
