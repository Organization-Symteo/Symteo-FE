//
//  AnxietyViewModel.swift
//  Symteo
//
//  Created by 박병선 on 1/19/26.
//
import SwiftUI
import Combine

@MainActor
final class AnxietyReportViewModel: ObservableObject {

    // MARK: - UI State
    @Published var isLoading: Bool = false
    @Published var errorToast: CustomToast?
    


    // MARK: - Server Raw Data
    @Published private(set) var summary: OverallSummary?
    @Published private(set) var overallResult: OverallResult =
        OverallResult(averageScore: 0, level: .safe) //UI 전용
    @Published private(set) var phqScore: Int = 0
    @Published private(set) var gadScore: Int = 0

    @Published private(set) var depressionDescription: String = ""
    @Published private(set) var anxietyDescription: String = ""

    @Published private(set) var phqClusters: [PHQ9ClusterResult] = []
    @Published private(set) var gadClusters: [GAD7ClusterResult] = []
    @Published private(set) var aiInsightCards: [AIInsightCard] = []
    @Published private(set) var isEmergency: Bool = false

    // MARK: - Identity
    let reportId: Int

    // MARK: - Dependency
    private let container: DIContainer
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    init(reportId: Int,  container: DIContainer) {
        self.reportId = reportId
        self.container = container
   
    }


    // MARK: - Derived (View 전용 데이터)

    /// 종합 결과 상태 (서버 판단 → UI Enum)
    var overallStatus: OverallResultStatus? {
        guard let label = summary?.statusLabel else { return nil }
        return OverallResultStatus(label: label)
    }

    /// 우울 결과 카드
    var depressionResult: DepressionResult {
        DepressionResult(
            score: phqScore,
            level: DepressionLevel.from(score: phqScore),
            clusters: phqClusters,
            description: depressionDescription
        )
    }

    /// 불안 결과 카드
    var anxietyResult: AnxietyResult {
        AnxietyResult(
            score: gadScore,
            level: AnxietyLevel.from(score: gadScore),
            clusters: gadClusters,
            description: anxietyDescription
        )
    }

    // MARK: - API
    func getAnxietyDepressionReport() {
        isLoading = true

        container.useCaseService.reportService
            .getDepressionAnxietyReport(reportId: reportId)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorToast = CustomToast(
                            title: "조회 실패",
                            message: error.errorDescription ?? "리포트를 불러오지 못했어요."
                        )
                        print("우울/불안 리포트 조회 오류:", error)
                    }
                },
                receiveValue: { [weak self] dto in
                    guard let self else { return }

                    // 1. 요약
                    self.summary = dto.summary

                    self.overallResult = OverallResult(
                        averageScore: dto.summary.averageScore,
                        level:  OverallResultStatus.from(label: dto.summary.statusLabel)
                    )
                    
                    // 2. 점수
                    self.phqScore = dto.phq9.totalScore
                    self.gadScore = dto.gad7.totalScore

                    // 3. AI 설명
                    self.depressionDescription = dto.depressionAiContent
                    self.anxietyDescription = dto.anxietyAiContent

                    // 4. 클러스터 (서버 → UI 모델)
                    self.phqClusters = dto.phq9.clusters.map {
                        PHQ9ClusterResult(
                            type: PHQ9ClusterType.from(serverName: $0.name),
                            rawScore: 0,
                            maxScore: 1,
                            ratio: $0.scoreRatio
                        )
                    }

                    self.gadClusters = dto.gad7.clusters.map {
                        GAD7ClusterResult(
                            type: GAD7ClusterType.from(serverName: $0.name),
                            rawScore: 0,
                            maxScore: 1,
                            ratio: $0.scoreRatio
                        )
                    }

                    // 5. 긴급 대응
                    self.isEmergency = dto.emergencyFlag
                    
                    // 6. ai 카드
                      self.aiInsightCards = dto.aiInsightCards
                }
            )
            .store(in: &cancellables)
    }
}
