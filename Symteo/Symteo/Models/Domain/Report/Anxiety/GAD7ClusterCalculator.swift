//
//  GADClusterCalculator.swift
//  Symteo
//
//  Created by 박병선 on 1/22/26.
//
import Foundation

struct GAD7ClusterCalculator {

    /// answers: GAD-7 전체 응답 (Q1~Q7), 각 0~3
    static func calculate(answers: [QuestionScore]) -> [GAD7ClusterResult] {
        precondition(answers.count >= 7, "GAD-7 answers must have at least 7 items")

        let policy: [(GAD7ClusterType, [Int], Int)] = [
            (.emotional, [0, 1, 2], 9),      // 1,2,3번
            (.physical,  [3, 4, 5, 6], 12)   // 4,5,6,7번
        ]

        return policy.map { type, indices, maxScore in
            let raw = indices
                .map { answers[$0].rawValue }
                .reduce(0, +)

            let ratio = Double(raw) / Double(maxScore)

            return GAD7ClusterResult(
                type: type,
                rawScore: raw,
                maxScore: maxScore,
                ratio: min(max(ratio, 0), 1)
            )
        }
    }
}
