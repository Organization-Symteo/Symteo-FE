//
//  DepressionSymtomClusterType.swift
//  Symteo
//
//  Created by 박병선 on 1/21/26.
//  우울증의 주요 증상 클러스터를 분류한 Enum입니다.

enum PHQ9ClusterType {
    case core
    case physical
    case psychological
}

extension PHQ9ClusterType {
    
    var title: String {
        switch self {
        case .core: return "핵심 증상"
        case .physical: return "신체 증상"
        case .psychological: return "심리 증상"
        }
    }
    
    var description: String {
        switch self {
        case .core: return "무기력, 즐거움 상실"
        case .physical: return "수면, 식욕, 피로"
        case .psychological: return "자책, 집중력, 초조"
        }
    }
}
