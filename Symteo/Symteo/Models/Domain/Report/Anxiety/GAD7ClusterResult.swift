//
//  GADClusterResult.swift
//  Symteo
//
//  Created by 박병선 on 1/22/26.
//
import Foundation

struct GAD7ClusterResult {
    let type: GAD7ClusterType
    let rawScore: Int
    let maxScore: Int
    let ratio: Double   // 0.0 ~ 1.0
}

