//
//  Depersonalization.swift
//  Symteo
//
//  Created by 박병선 on 1/25/26.
//

import SwiftUI

// 비인격화용 Enum
enum Depersonalization: String {
    case veryLow = "매우 낮음"
    case low = "낮음"
    case normal = "보통"
    case severe = "높음"
    case verySevere = "매우 심각"
}

extension Depersonalization {

    static func from(text: String) -> Depersonalization {
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
            return "사람들과의 관계가 비교적 원활해요."
        case .low:
            return "적당한 거리감을 유지하고 있어요."
        case .normal:
            return "타인에 대한 관심이 줄어들고 있어요."
        case .severe:
            return "사람들과 감정적으로 멀어지고 있어요."
        case .verySevere:
            return "대인 관계를 피하고 싶어져요."
        }
    }
}
