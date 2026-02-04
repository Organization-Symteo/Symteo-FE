//
//  StressProgressSeverity.swift
//  Symteo
//
//  Created by 박병선 on 1/25/26.
//  스트레스 리포트에서 클러스터바의 UI를 구분하기 위한 enum입니다. 
import SwiftUI

enum StressProgressSeverity {
    case veryLow
    case low
    case normal
    case high

   
    static func from(ratio: Double) -> StressProgressSeverity {
        switch ratio {
           case 0.0...0.25:
            return .veryLow
           case 0.26...0.50:
            return .low
           case 0.51...0.75:
            return .normal
        default:
               return .high
           }
       }
    
    var progressColor: Color {
        switch self {
        case .veryLow: return Color(hex: "#F4574F")
        case .low:     return Color(hex: "#FFAC79")
        case .normal:  return Color(hex: "#FFE8A9")
        case .high:    return Color(hex: "#63B19B")
        }
    }

    var title: String {
        switch self {
        case .veryLow: return "매우 낮음"
        case .low:     return "낮음"
        case .normal:  return "보통"
        case .high:    return "높음"
        }
    }
}
