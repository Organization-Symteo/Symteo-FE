//
//  AnxietyLevel.swift
//  Symteo
//
//  Created by 박병선 on 1/20/26.
//
//  불안 레벨을 분류한 Enum입니다.
import SwiftUI

enum AnxietyLevel {
    case minimal      // 0~4
    case mild         // 5~9
    case moderate     // 10~14
    case severe       // 15 이상
}

extension AnxietyLevel {
    static func from(score: Int) -> AnxietyLevel {
        switch score {
        case 0...4:
            return .minimal // 최소
        case 5...9:
            return .mild // 경도
        case 10...14:
            return .moderate // 중증도
        default:
            return .severe //고도
        }
    }
    
    // 결과에 따른 이미지를 나타냅니다.
    var imageName: String {
        switch self {
        case .minimal:
            return "anxiety1"
        case .mild:
            return "anxiety2"
        case .moderate:
            return "anxiety3"
        case .severe:
            return "anxiety4"
        }
    }
    
    var title: String {
        switch self {
        case .minimal:
            return "최소"
        case .mild:
            return "경도"
        case .moderate:
            return "중증도"
        case .severe:
            return "고도"
        }
    }
    
    var titleColor: Color {
        switch self {
        case .minimal:
            return Color(hex: "63B19B")
        case .mild:
            return Color(hex: "FFE8A9")
        case .moderate:
            return Color(hex: "FFAC79")
        case .severe:
            return Color(hex: "F4574F")
        }
    }
}
