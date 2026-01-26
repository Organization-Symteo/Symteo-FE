//
//  Untitled.swift
//  Symteo
//
//  Created by 박병선 on 1/26/26.
//
import SwiftUI

enum AttachmentBarLevel {
    case veryLow
    case low
    case medium
    case high

    // 퍼센트 → 레벨
    static func from(ratio: Double) -> AttachmentBarLevel {
        switch ratio {
        case 0.0...0.25:
            return .veryLow
        case 0.26...0.50:
            return .low
        case 0.51...0.75:
            return .medium
        default:
            return .high
        }
    }

    // UI 색상
    var color: Color {
        switch self {
        case .veryLow: return Color(hex: "#63B19B") // 초록
        case .low:     return Color(hex: "#FFE8A9") // 노랑
        case .medium:  return Color(hex: "#FFAC79") // 주황
        case .high:    return Color(hex: "#F4574F") // 빨강
        }
    }

    // 상태 라벨
    var title: String {
        switch self {
        case .veryLow: return "매우 낮음"
        case .low:     return "낮음"
        case .medium:  return "보통"
        case .high:    return "높음"
        }
    }

    // 지표별 설명 멘트
    func description(for metric: AttachmentMetricType) -> String {
        switch metric {
        case .anxiety:
            switch self {
            case .veryLow:
                return "정서적으로 안정적이고 신뢰감이 높아요."
            case .low:
                return "관계에서 비교적 편안함을 느껴요."
            case .medium:
                return "상대의 반응에 조금 민감해지는 편이에요."
            case .high:
                return "상대의 반응에 많이 예민해요."
            }

        case .avoidance:
            switch self {
            case .veryLow:
                return "친밀한 관계 형성에 비교적 적극적이에요."
            case .low:
                return "가까움과 거리 사이의 균형을 유지해요."
            case .medium:
                return "개인적인 공간이 필요해지는 편이에요."
            case .high:
                return "심리적 거리를 두고 싶어져요."
            }
        }
    }
}
