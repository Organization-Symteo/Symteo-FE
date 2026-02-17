//
//  StressViewModel.swift
//  Symteo
//
//  Created by 박병선 on 1/19/26.
//
import SwiftUI
import Combine
import Moya


// 이 파일에 있는 API 함수 : getStressReport() 
@MainActor
final class StressReportViewModel: ObservableObject {

    // 로딩 상태
    @Published var isLoading: Bool = false
    
    // 에러 토스트
    @Published var errorToast: CustomToast?

    // 서버에서 내려오는 배터리 원본 데이터
    @Published var batteryPercent: Int = 0
    @Published var batteryGuide: String = ""
    @Published var batteryColorHex: String = ""

    // 스트레스 관련 서버 데이터
    @Published var pssScore: Int = 0
    @Published var stressLevelText: String = ""
    @Published var controlLevelText: String = ""
    @Published var overloadLevelText: String = ""
    
    // 번아웃 관련 서버 데이터
    @Published var exhaustionLevelText: String = ""
    @Published var cynicismLevelText: String = ""
    @Published var inefficacyLevelText: String = ""
    @Published var totalBurnoutLevelText: String = ""

    // AI 분석 결과
    @Published var aiInsights: [String] = []
    @Published var aiFullContent: String = ""

    // 리포트 식별 정보
    let reportId: Int


    // 의존성
    private let container: DIContainer
    private var cancellables = Set<AnyCancellable>()

    init(
        reportId: Int,

        container: DIContainer
    ) {
        self.reportId = reportId

        self.container = container
    }

    // MARK: - Battery
    /// 배터리 상태
    var batteryStatus: BatteryStatus {
        BatteryStatus.from(percent: batteryPercent)
    }

    /// 실제 보여줄 배터리 이미지
    var batteryImageName: String {
        batteryStatus.batteryImage
    }
    
    /// 배경 컬러
    var batteryBackgroundColor: Color {
        batteryStatus.backgroundColor
    }

    /// 배터리 설명
    var batteryGuideText: String {
        batteryStatus.guideText
    }

    // MARK: -스트레스
    /// 스트레스 레벨 enum 변환
    var stressLevel: StressLevel {
        StressLevel.from(text: stressLevelText)
    }
 
    /// 스트레스 색상
    var stressColor: Color {
        stressLevel.color
    }
    
    /// 온도계 이미지
    var stressImageName: String {
        stressLevel.imageName
    }
    /// 스트레스 설명 문구
    var stressDescriptionText: String {
        stressLevel.description
    }

    // 통제감 결과 UI 모델
    var situationalControlResult: StressBalanceResult {
        StressBalanceResult.fromControlLevel(controlLevelText)
    }

    // 과부하 결과 UI 모델
    var dailyOverloadResult: StressBalanceResult {
        StressBalanceResult.fromOverloadLevel(overloadLevelText)
    }

    // MARK: - 번아웃
    // 번아웃 결과 묶음
    var burnoutResult: BurnoutResult {
        BurnoutResult(
            exhaustionLevel: exhaustionLevelText,
            cynicismLevel: cynicismLevelText,
            inefficacyLevel: inefficacyLevelText,
            totalLevel: totalBurnoutLevelText
        )
    }
    
    // 정서적 소진 enum
    var emotionalExhaustion: EmotionalExhaustion {
        EmotionalExhaustion.from(text: exhaustionLevelText)
    }

    // 성취감 저하 enum
    var personalAccomplishment: PersonalAccomplishment {
        PersonalAccomplishment.from(text: inefficacyLevelText)
    }

    // 비인격화 enum
    var depersonalization: Depersonalization {
        Depersonalization.from(text: cynicismLevelText)
    }

    // MARK: - 스트레스 리포트 조회 API
    func getStressReport() {
        isLoading = true

        container.useCaseService.reportService.getStressReport(reportId: reportId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let failure) = completion {
                        self?.errorToast = CustomToast(
                            title: "조회 실패",
                            message: failure.errorDescription ?? "리포트를 불러오지 못했어요."
                        )
                        print("스트레스 리포트 조회 오류:", failure)
                    }
                },
                receiveValue: { [weak self] report in
                    self?.bind(report)
                }
            )
            .store(in: &cancellables)
    }

    // 서버 응답 → ViewModel 상태 바인딩
    private func bind(_ report: StressReportDetail) {
        batteryPercent = report.batteryPercent
        batteryGuide = report.batteryGuide
        batteryColorHex = report.batteryColor

        pssScore = report.stress.pssScore
        stressLevelText = report.stress.stressLevel
        controlLevelText = report.stress.controlLevel
        overloadLevelText = report.stress.overloadLevel

        exhaustionLevelText = report.burnout.exhaustionLevel
        cynicismLevelText = report.burnout.cynicismLevel
        inefficacyLevelText = report.burnout.inefficacyLevel
        totalBurnoutLevelText = report.burnout.totalLevel

        aiInsights = report.aiInsights
        aiFullContent = report.aiFullContent
    }
}
