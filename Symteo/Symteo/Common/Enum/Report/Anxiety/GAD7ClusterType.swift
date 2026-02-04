//
//  AnxietySymtomClusterType.swift
//  Symteo
//
//  Created by 박병선 on 1/21/26.
//
enum GAD7ClusterType {
    case emotional
    case physical
}

extension GAD7ClusterType {
    var title: String {
        switch self{
        case .emotional:
            return "정서적 불안"
        case .physical:
            return "신체적 긴장"
        }
    }
    
    var description: String {
        switch self {
        case . emotional:
            return "걱정, 초조"
        case .physical:
            return "안달감, 짜증, 근육긴장"
        }
    }
}
