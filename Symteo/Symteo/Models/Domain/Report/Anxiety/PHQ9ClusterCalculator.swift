//
//  PHQ9ClusterCalculator.swift
//  Symteo
//
//  Created by 박병선 on 1/21/26.
//
//  PHQ-9의 점수를 계산하여 리포트 화면에 띄우는 역할을 하는 구조체입니다. 
import Foundation


struct PHQ9ClusterCalculator {

    /// answers: PHQ-9 전체 응답 (Q1~Q9), 각 0~3
    static func calculate(answers: [QuestionScore]) -> [PHQ9ClusterResult] {
        precondition(answers.count >= 8)

        //
        let policy: [(PHQ9ClusterType, [Int], Int)] = [
            (.core, [0, 1], 6),          // 1,2번
            (.physical, [2, 3, 4], 9),   // 3,4,5번
            (.psychological, [5, 6, 7], 9) // 6,7,8번
        ]

        return policy.map { (type, indices, maxScore) in
            let raw = indices
                .map { answers[$0].rawValue }
                .reduce(0, +)

            let ratio = Double(raw) / Double(maxScore)

            return PHQ9ClusterResult(
                type: type,
                rawScore: raw,
                maxScore: maxScore,
                ratio: min(max(ratio, 0), 1)
            )
        }
    }
}
