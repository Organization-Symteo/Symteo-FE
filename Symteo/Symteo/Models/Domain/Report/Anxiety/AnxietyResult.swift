//
//  AnxietyResult.swift
//  Symteo
//
//  Created by 박병선 on 1/22/26.
//
import Foundation


struct AnxietyResult {
    let score: Int
    let level: AnxietyLevel
    let clusters: [GAD7ClusterResult]
    let description: String?
}

/*
/// 프리뷰용 더미데이터
extension AnxietyResult {

    static let preview: AnxietyResult = AnxietyResult(
        score: 13,
        level: .moderate,
        clusters: [
            GAD7ClusterResult(
                type: .emotional,
                rawScore: 3,
                maxScore: 6,
                ratio: 0.5
            ),
            GAD7ClusterResult(
                type: .physical,
                rawScore: 5,
                maxScore: 9,
                ratio: 0.55
                )
        ],
        description: "현재 불안 상태는 중증도 입니다.현재 불안 상태는 중증도 입니다. 현재 불안 상태는 중증도 입니다. 현재 불안 상태는 중증도 입니다. 현재 불안 상태는 중증도 입니다. "
    )
}
*/


