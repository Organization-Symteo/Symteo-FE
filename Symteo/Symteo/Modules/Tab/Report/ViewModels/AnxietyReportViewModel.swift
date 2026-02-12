//
//  AnxietyViewModel.swift
//  Symteo
//
//  Created by 박병선 on 1/19/26.
//
import Foundation
import Combine


final class AnxietyReportViewModel: ObservableObject {
    @Published var currentStatus: OverallResultStatus = .caution // 현재 결과값
    @Published var score: Int = 65 // 실제 점수

    
    let phqScore: Int
    let gadScore: Int
    let overallResult: OverallResult

     
     
    // MARK: TODO 실제 사용자 이름
    let userName: String = "따오기"
    let totalLevel: String = "경도"
    let description: String = "현재우울상태는불안입니다"
    // 예시: PHQ-9 응답 (Q1~Q9)
    let phqAnswers: [QuestionScore] = [
            .severalDays, .moreThanWeek, .nearlyEveryDay,
            .severalDays, .severalDays, .moreThanWeek,
            .severalDays, .notAtAll, .severalDays
        ]
    
    
    //  MARK: -initializer
    init(phqScore: Int, gadScore: Int) {
        self.phqScore = phqScore
        self.gadScore = gadScore
        self.overallResult = OverallResultCalculator.calculate(
            phqScore: phqScore,
            gadScore: gadScore
        )
    }
    
    // MARK: -var
    
    /// 우울 클러스터 결과
    var phqClusterResults: [PHQ9ClusterResult] {
            PHQ9ClusterCalculator.calculate(answers: phqAnswers)
        }
    
    // 종합 결과
    var overallLevel: OverallResultStatus {
        OverallResultStatus.from(phqScore: phqScore, gadScore: gadScore)
    }
    
    //  View에서 바로 쓰는 데이터
    var overallResultImageName: String {
        overallLevel.resultImage
    }
    
    var depressionData: DepressionResult {
           DepressionResult(
               score: phqScore,
               level: DepressionLevel.from(score: phqScore),
               clusters: phqClusterResults,
               description: nil
           )
       }
    
}
