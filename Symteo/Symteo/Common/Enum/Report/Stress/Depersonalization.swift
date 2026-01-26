//
//  Depersonalization.swift
//  Symteo
//
//  Created by 박병선 on 1/25/26.
//

import SwiftUI

// 일상 과부화 단계를 나타내는 Enum입니다.
enum Depersonalization {
    case veryLow
    case low
    case normal
    case severe
    case verySevere
}

extension Depersonalization {

    static func from(ratio: Double) -> Self {
           switch ratio {
           case 0...0.20: return .veryLow
           case 0.21...0.40: return .low
           case 0.41...0.60: return .normal
           case 0.61...0.80: return .severe
           default: return .verySevere
           }
       }


    var title: String {
        switch self {
        case .veryLow: return "매우 낮음"
        case .low: return "낮음"
        case .normal: return "보통"
        case .severe: return "높음"
        case .verySevere: return "매우 높음"
        }
    }
    
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
