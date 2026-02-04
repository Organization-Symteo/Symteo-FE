//
//  PHQ9ClusterResult.swift
//  Symteo
//
//  Created by 박병선 on 1/21/26.
//
import Foundation

struct PHQ9ClusterResult {
    let type: PHQ9ClusterType
    let rawScore: Int
    let maxScore: Int
    let ratio: Double   // 0.0 ~ 1.0
}
