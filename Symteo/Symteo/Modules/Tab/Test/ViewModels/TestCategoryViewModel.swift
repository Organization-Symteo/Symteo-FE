//
//  TestCategoryViewModel.swift
//  Symteo
//
//  Created by 김지우 on 1/18/26.
//

import Foundation
import SwiftUI
import Combine

class TestCategoryViewModel: ObservableObject {
    @Published var depressionTest: TestCategoryModel
    @Published var stressTest: TestCategoryModel
    @Published var typeTest: TestCategoryModel
    
    init() {
        
        // 공통 추천 테스트 데이터
        let recDepression = Recommendation(title: "우울·불안 검사", icon: "depressionmini",destination:.depressionTest)
        let recStress = Recommendation(title: "스트레스 측정", icon: "stressmini",destination: .stressTest)
        let recType = Recommendation(title: "성향 검사", icon: "typemini",destination: .typeTest)
        
        self.depressionTest = TestCategoryModel(
            title: "우울 · 불안 검사",
            description: "마음이 자꾸만 무겁고\n가라앉는다면?",
            themeColor: "green50",
            mainImage: "depressionimage",
            infoText: "16문항, 2-4분 소요",
            startButtonTitle: "우울·불안 측정 시작",
            caution:"*본 검사는 [PHQ-9, GAD] 표준 척도를 기반으로 제작되었으며,\n의학적 진단을 대신할 수 없습니다.",
            questions: [
                "마음이 자꾸만 무겁고 가라앉아요",
                "막연한 불안감으로 밤잠을 설쳐요",
                "현재 내 마음 건강을 진단해보고 싶어요"
            ],
            emojis:["crying","disappointed","confused"],
            recommendations: [recStress, recType]
        )
        
        self.stressTest = TestCategoryModel(
            title: "스트레스 검사",
            description: "혹시 나도 번아웃일까\n궁금하다면?",
            themeColor: "pink100",
            mainImage: "stressimage",
            infoText: "32문항, 5-8분 소요",
            startButtonTitle: "스트레스 측정 시작",
            caution:"*본 검사는 [Perceived Stress Scale: PSS] 표준 척도를 기반으로 제작되\n었으며, 의학적 진단을 대신할 수 없습니다.",
            questions: [
                "과도한 학업과 업무로 마음이 지쳐요",
                "끝이 보이지 않는 취업 준비가 버거워요",
                "'혹시 나도 번아웃일까?' 확인해보고 싶어요"
            ],
            emojis:["crying","fearful","headband"],
            recommendations: [recDepression, recType]

        )
        
        self.typeTest = TestCategoryModel(
            title: "성향 검사",
            description: "내가 어떤 유형의 사람\n인지 궁금하다면?",
            themeColor: "yellow100",
            mainImage: "typeimage",
            infoText: "36문항, 5-8분 소요",
            startButtonTitle: "성향 검사 시작",
            caution:"*본 검사는 [ECR-R] 표준 척도를 기반으로 제작되었으며, 의학적 진단을 대\n신할 수 없습니다.",
            questions: [
                "누군가와 깊은 관계를 맺는 게 부담스럽고 어려워요",
                "원래 무심한 성격인 걸까? 상처받기 싫어 피하는 걸까? 궁금해요"
            ],
            emojis:["crying","crying","disappointed"],
            recommendations: [recDepression, recStress]

        )
    }
}
