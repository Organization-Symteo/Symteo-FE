//
//  BatteryStatus.swift
//  Symteo
//
//  Created by 박병선 on 1/22/26.
//
//   BatteryStatus
//  스트레스(PSS)와 번아웃 결과를 기반으로 산출된 '마음 배터리' 상태를 표현하는 도메인 Enum입니다.

import SwiftUI

enum BatteryStatus {
    case veryLow, low, medium, high

    static func from(percent: Int) -> BatteryStatus {
        switch percent {
        case 0...25: return .veryLow
        case 26...50: return .low
        case 51...75: return .medium
        default: return .high
        }
    }

    var description: String {
        switch self {
        case .veryLow:
            return "지금 당장 휴식이 필요합니다."
        case .low:
            return "에너지가 많이 고갈되었습니다. 주의가 필요해요."
        case .medium:
            return "조금씩 지쳐가고 있어요. 나를 돌봐주세요."
        case .high:
            return "마음 에너지가 충분합니다. 아주 좋아요!"
        }
    }

    var backgroundColor: Color {
        switch self {
        case .veryLow: return Color(hex: "#FFEAEA")
        case .low: return Color(hex: "#FCEDE1")
        case .medium: return Color(hex: "#FFF7E1")
        case .high: return Color(hex: "#ECFFF8")
        }
    }
    var titleColor: Color {
        switch self {
        case .veryLow: return Color(hex: "#ED3F36")
        case .low: return Color(hex: "#F74C29")
        case .medium: return Color(hex: "#E96045")
        case .high: return Color(hex: "#359F82")
        }
    }
    
    var batteryImage: String {
           switch self {
           case .veryLow: return "battery_red"
           case .low: return "battery_orange"
           case .medium: return "battery_yellow"
           case .high: return "battery_green"
           }
       }
}
