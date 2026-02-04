//
//  DepressionLevel.swift
//  Symteo
//
//  Created by 박병선 on 1/20/26.
//
//  우울증 레벨을 분류한 Enum입니다.
import Foundation
import SwiftUI

enum DepressionLevel {
    case minimal      // 0~4
    case mild         // 5~9
    case moderate     // 10~14
    case moderatelySevere // 15~19
    case severe       // 20+
}

extension DepressionLevel {
    static func from(score: Int) -> DepressionLevel {
        switch score {
        case 0...4:
            return .minimal // 최소
        case 5...9:
            return .mild // 경도
        case 10...14:
            return .moderate // 중증도
        case 15...19:
            return .moderatelySevere //중증고도
        default:
            return .severe //고도
        }
    }
    
    // 결과에 따른 이미지를 나타냅니다.
    var imageName: String {
        switch self {
        case .minimal:
            return "depression1"
        case .mild:
            return "depression2"
        case .moderate:
            return "depression3"
        case .moderatelySevere:
            return "depression4"
        case .severe:
            return "depression5"
        }
    }
    
    // 결과에 따른 title을 나타냅니다.
    var title: String {
        switch self {
        case .minimal:
            return "최소"
        case .mild:
            return "경도"
        case .moderate:
            return "중증도"
        case .moderatelySevere:
            return "중증고도"
        case .severe:
            return "고도"
        }
    }
    
    var titleColor: Color {
        switch self {
        case .minimal:
            return Color(hex: "63B19B")
        case .mild:
            return Color(hex: "A9D6D0")
        case .moderate:
            return Color(hex: "FFE8A9")
        case .moderatelySevere:
            return Color(hex: "FFAC79")
        case .severe:
            return Color(hex: "F4574F")
        }
    }
}
