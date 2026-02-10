//
//  AnxietyReport.swift
//  Symteo
//
//  Created by 박병선 on 1/19/26.
//  우울/불안 종합 점수를 분류한 Enum입니다.
import SwiftUI

enum OverallResultStatus {
    case safe          // 안정
    case stable        // 양호
    case caution       // 주의
    case attention     // 관리 필요
    case emergency     // 즉시 도움 필요
}

// MARK: - Server → UI Mapping
extension OverallResultStatus {

    /// 서버 statusLabel 기반 초기화
    init?(label: String) {
        switch label {
        case "안정":
            self = .safe
        case "양호":
            self = .stable
        case "주의":
            self = .caution
        case "관리 필요":
            self = .attention
        case "즉시 도움 필요":
            self = .emergency
        default:
            return nil
        }
    }
    
    static func from(label: String) -> OverallResultStatus {
         switch label {
         case "안정": return .safe
         case "양호": return .stable
         case "주의": return .caution
         case "관리 필요": return .attention
         case "즉시 도움 필요": return .emergency
         default: return .safe
         }
     }

    // MARK: - UI Properties

    var title: String {
        switch self {
        case .safe:      return "안정 단계"
        case .stable:    return "양호 단계"
        case .caution:   return "주의 단계"
        case .attention: return "관리 필요 단계"
        case .emergency: return "즉시 도움 필요"
        }
    }

    var subtitle: String {
        switch self {
        case .safe:
            return "No Clinical Concern"
        case .stable:
            return "Generally Stable"
        case .caution:
            return "Monitoring Recommended"
        case .attention:
            return "Clinical Attention Needed"
        case .emergency:
            return "Immediate Support Required"
        }
    }

    var backgroundColor: Color {
        switch self {
        case .safe:
            return Color(hex: "#ECFFF8")
        case .stable:
            return Color(hex: "#E6F6F8")
        case .caution:
            return Color(hex: "#FFF7E1")
        case .attention:
            return Color(hex: "#FCEDE1")
        case .emergency:
            return Color(hex: "#FFEBEA")
        }
    }

    var titleColor: Color {
        switch self {
        case .safe:
            return Color(hex: "#359F82")
        case .stable:
            return Color(hex: "#429A8E")
        case .caution:
            return Color(hex: "#E96045")
        case .attention:
            return Color(hex: "#F74C29")
        case .emergency:
            return Color(hex: "#ED3F36")
        }
    }

    var resultImage: String {
        switch self {
        case .safe:      return "dep_state_safe"
        case .stable:    return "dep_state_stable"
        case .caution:   return "dep_state_caution"
        case .attention: return "dep_state_attention"
        case .emergency: return "dep_state_emergency"
        }
    }
}
