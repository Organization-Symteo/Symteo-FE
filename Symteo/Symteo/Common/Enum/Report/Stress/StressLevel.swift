//
//  StressLevel.swift
//  Symteo
//
//  Created by 박병선 on 1/22/26.
//
import SwiftUI

enum StressLevel {
    case good        // 양호
    case caution     // 주의
    case danger      // 위험
    case critical    // 매우 위험

    // MARK: - 점수 → 등급 변환
    static func from(score: Int) -> StressLevel {
        switch score {
        case 0...13:
            return .good
        case 14...26:
            return .caution
        case 27...30:
            return .danger
        default:
            return .critical
        }
    }

    // MARK: - UI 색상
    var color: Color {
        switch self {
        case .good:
            return Color(hex: "#63B19B")   // 초록
        case .caution:
            return Color(hex: "#FFE8A9")   // 노랑
        case .danger:
            return Color(hex: "#FFAC79")   // 주황
        case .critical:
            return Color(hex: "#F4574F")   // 빨강
        }
    }

    // MARK: - 상태 텍스트
    var title: String {
        switch self {
        case .good:
            return "양호"
        case .caution:
            return "주의"
        case .danger:
            return "위험"
        case .critical:
            return "매우 위험"
        }
    }

    // MARK: - 상세 멘트 (서버 오기 전까지는 로컬)
    var description: String {
        switch self {
        case .good:
            return "현재 스트레스 수준이 낮고 관리가 잘 되고 있습니다."
        case .caution:
            return "일상적인 스트레스가 체감되기 시작합니다. 가벼운 산책을 추천해요."
        case .danger:
            return "스트레스로 인해 일상에 불편함을 느낄 수 있습니다. 관리가 필요합니다."
        case .critical:
            return "심리적으로 많이 지친 상태입니다. 전문적인 상담이나 심층 진단을 권장해요."
        }
    }
    
    
    // MARK: - 상세 점수 
    var rangeText: String {
           switch self {
           case .good: return "0~13점"
           case .caution: return "14~26점"
           case .danger: return "27~30점"
           case .critical: return "31점 이상"
           }
       }
}
