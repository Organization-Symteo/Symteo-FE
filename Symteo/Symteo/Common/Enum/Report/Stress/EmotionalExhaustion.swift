//
//  EmotionalExhaustion.swift
//  Symteo
//
//  Created by 박병선 on 1/25/26.
//
//  정서적 소진 전용 Enum
import SwiftUI

enum EmotionalExhaustion: String {
    case veryLow = "매우 낮음"
    case low = "낮음"
    case normal = "보통"
    case severe = "높음"
    case verySevere = "매우 심각"
}

extension EmotionalExhaustion {
    
    static func from(text: String) -> EmotionalExhaustion {
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
        case .veryLow: return "심리적 에너지가 충분해요."
        case .low: return "피로는 있지만 회복할 수 있어요."
        case .normal: return "피로가 쌓여 에너지가 정체돼 있어요."
        case .severe: return "쉬어도 쉽게 회복되지 않아요."
        case .verySevere: return "정서적 에너지가 거의 소진됐어요."
        }
    }
}
