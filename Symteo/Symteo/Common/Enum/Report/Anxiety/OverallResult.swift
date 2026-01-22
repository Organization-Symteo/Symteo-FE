//
//  AnxietyReport.swift
//  Symteo
//
//  Created by 박병선 on 1/19/26.
//  우울/불안 종합 점수를 분류한 Enum입니다. 
enum OverallResult {
    case safe
    case stable
    case caution
    case attention
    case emergency
}

extension OverallResult {
    static func from(phqScore: Int, gadScore: Int) -> OverallResult {
        let average = phqScore + gadScore / 2
        
        switch average {
        case 0...4:
            return .safe
        case 5...9:
            return .stable
        case 10...14:
            return .caution
        case 15...19:
            return .attention
        default:
            return .emergency
        }
    }
    
    var resultImage: String {
        switch self {
        case .safe: return "dep_state_safe"
        case .stable: return "dep_state_stable"
        case .caution: return "dep_state_caution"
        case .attention: return "dep_state_attention"
        case .emergency: return "dep_state_emergency"
        }
    }
}
