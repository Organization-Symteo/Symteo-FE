//
//  TestingViewModel.swift
//  Symteo
//
//  Created by 김지우 on 1/25/26.
//

import Foundation
import SwiftUI
import Combine

// (참고용) 모델이 이렇게 정의되어 있다고 가정합니다.
// struct QuestionsModel: Identifiable {
//     let id: UUID
//     let text: String
//     let options: [String]
// }

class SurveyViewModel: ObservableObject {
    // 질문 목록 데이터
    @Published var questions: [QuestionsModel] = []
    
    // 상태(현재 페이지, 답변 모음)
    @Published var currentIndex: Int = 0
    @Published var answers: [Int: String] = [:] // [질문인덱스: 선택한답변]
    
    // 기본 옵션(4점 척도)
    private let defaultOptions = ["전혀 없었다", "며칠정도", "일주일 이상", "거의 매일"]
    
    // MARK: - 초기화 (데이터 로드)
    init() {
        // 1. PHQ-9 (우울) 질문
        let phq9 = [
            "지난 2주일 동안, 일 또는 여가 활동을 하는 데 흥미나 즐거움을 느끼지 못함",
            "지난 2주일 동안, 기분이 가라앉거나, 우울하거나, 희망이 없음",
            "지난 2주일 동안, 잠이 들거나 계속 잠을 자는 것이 어려움, 또는 잠을 너무 많이 잠",
            "지난 2주일 동안, 피곤하다고 느끼거나 기운이 거의 없음",
            "지난 2주일 동안, 입맛이 없거나 과식을 함",
            "지난 2주일 동안, 자신을 부정적으로 봄 - 혹은 자신이 실패자라고 느끼거나 자신 또는 가족을 실망시킴",
            "지난 2주일 동안, 신문을 읽거나 텔레비전 보는 것과 같은 일에 집중하는 것이 어려움",
            "지난 2주일 동안, 다른 사람들이 주목할 정도로 너무 느리게 움직이거나 말을 함. 또는 반대로 평상시보다 많이 움직여서, 너무 안절부절못하거나 들떠 있음",
            "지난 2주일 동안, 자신이 죽는 것이 더 낫다고 생각하거나 어떤 식으로든 자신을 해칠 것이라고 생각함"
        ]
        
        // 2. GAD-7 (불안) 질문
        let gad7 = [
            "지난 2주일 동안, 초조하거나 불안하거나 조마조마하게 느낀다",
            "지난 2주일 동안, 걱정하는 것을 멈추거나 조절할 수가 없다",
            "지난 2주일 동안, 여러 가지 것들에 대해 걱정을 너무 많이 한다",
            "지난 2주일 동안, 편하게 있기가 어렵다",
            "지난 2주일 동안, 너무 안절부절못해서 가만히 있기가 힘들다",
            "지난 2주일 동안, 쉽게 짜증이 나거나 쉽게 성을 내게 된다",
            "지난 2주일 동안, 마치 끔찍한 일이 생길 것처럼 두렵게 느껴진다"
        ]
        
        // 3. 통합 및 모델 변환 (id: UUID() 명시)
        let allTexts = phq9 + gad7
        self.questions = allTexts.map { text in
            QuestionsModel(id: UUID(), text: text, options: defaultOptions)
        }
    }
    
    // MARK: - 뷰 데이터 가공
    
    // 현재 보여지는 질문 객체
    var currentQuestion: QuestionsModel {
        // 데이터가 아직 없을 경우 대비 안전처리
        guard !questions.isEmpty else {
            return QuestionsModel(id: UUID(), text: "", options: [])
        }
        return questions[currentIndex]
    }
    
    // 진행률 (0.0 ~ 1.0)
    var progress: CGFloat {
        guard !questions.isEmpty else { return 0 }
        return CGFloat(currentIndex + 1) / CGFloat(questions.count)
    }
    
    // 현재 질문 번호 문자열 (예: "01")
    var currentNumberString: String {
        String(format: "%02d", currentIndex + 1)
    }
    
    // 전체 질문 수 문자열 (예: "16")
    var totalCountString: String {
        String(format: "%d", questions.count)
    }
    
    // MARK: - 기능 함수들
    
    // 답변 선택
    func selectOption(_ option: String) {
        answers[currentIndex] = option
    }
    
    // 다음 질문으로 이동
    func nextQuestion() {
        if currentIndex < questions.count - 1 {
            currentIndex += 1
        } else {
            print("진단 완료! 결과 페이지로 이동 로직 수행")
            // TODO: 결과 처리 로직
        }
    }
    
    // 이전 질문으로 이동
    func prevQuestion() {
        if currentIndex > 0 {
            currentIndex -= 1
        }
    }
    
    // 특정 옵션이 선택되었는지 확인
    func isSelected(_ option: String) -> Bool {
        return answers[currentIndex] == option
    }
}
