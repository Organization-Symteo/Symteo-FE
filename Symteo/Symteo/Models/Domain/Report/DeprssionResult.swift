//
//  DeprssionResult.swift
//  Symteo
//
//  Created by 박병선 on 1/22/26.
//
import Foundation

struct DepressionResult {
    let score: Int
    let level: DepressionLevel
    let clusters: [PHQ9ClusterResult]
    let description: String?
}

/// 프리뷰용 더미데이터
extension DepressionResult {

    static let preview: DepressionResult = DepressionResult(
        score: 13,
        level: .moderate,
        clusters: [
            PHQ9ClusterResult(
                type: .core,
                rawScore: 3,
                maxScore: 6,
                ratio: 0.5
            ),
            PHQ9ClusterResult(
                type: .physical,
                rawScore: 5,
                maxScore: 9,
                ratio: 0.55
            ),
            PHQ9ClusterResult(
                type: .psychological,
                rawScore: 6,
                maxScore: 9,
                ratio: 0.66
            )
        ],
        description: "현재 우울 상태는 중증도 입니다.현재 우울 상태는 중증도 입니다. 현재 우울 상태는 중증도 입니다. 현재 우울 상태는 중증도 입니다. 현재 우울 상태는 중증도 입니다. "
    )
}
