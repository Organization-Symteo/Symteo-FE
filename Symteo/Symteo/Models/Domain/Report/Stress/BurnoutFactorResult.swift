//
//  BurnoutFactorResult.swift
//  Symteo
//
//  Created by 박병선 on 1/26/26.
//
// 번아웃 3요인 결과 모델 (UI용)
import Foundation
import SwiftUI

struct BurnoutFactorResult {
    let title: String          // 정서적 소진, 성취감 저하, 비인격화
    let levelText: String      // 매우 심각
    let description: String    // 마음의 에너지가 바닥났어요
    let ratio: Double          // 0.0 ~ 1.0
    let color: Color
}
