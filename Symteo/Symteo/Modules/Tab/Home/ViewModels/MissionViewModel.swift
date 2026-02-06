//
//  MissionViewModel.swift
//  Symteo
//
//  Created by 박병선 on 1/7/26.
//
import Foundation
import SwiftUI
import Combine

final class MissionViewModel: ObservableObject {
    // MARK: - Toast
    @Published var toast: CustomToast? = nil
    
    // 흐름 상태
    @Published var uiState: MissionState = .arrived
    
    // 입력 데이터
    @Published var selectedImages: [UIImage] = []
    @Published var memo: String = ""
    

    @Published var userMissionId: Int?
    @Published var isLoading: Bool = false //현재 데이터를 불러오는 중인지 여부
    @Published var missionContent: String = "" // 오늘의 미션 내용(텍스트) 저장용 상태
    @Published var remainingSeconds: Int = 0 // 서버 기준 남은시간
    @Published var restarted: Bool = false // 새로 고침 가능 여부
    @Published var missionId: Int? // 이건 오늘의 미션 고유 ID (오늘 미션 조회 API 응답에 포함돼야 하는 값)
    @Published var uploadedImageUrl: String? // Presigned URL 업로드 이후 서버에 보낼 이미지 URL
    @Published var errorMessage: String?
    @Published var refreshCount: Int = 0
    @Published var timeRemaining: Int = 0
    @Published var currentMission: String = ""
    private var timer: AnyCancellable?
    
    // MARK: - 의존성 주입 및 비동기 처리
    /// DIContainer를 통해 의존성 주입
    let container: DIContainer
    /// Combine 구독 해제를 위한 Set
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - 초기화
    init(container: DIContainer) {
        self.container = container
    }
    
    /// 서버에서 내려준 remainingSeconds를 감소시키는 용도로만 사용
    func startTimer() {
        timer?.cancel()
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                }
            }
    }
    
    // UI 포맷 변경 함수 (초->시간,분)
    func timeRemainingString() -> String {
        let hours = timeRemaining / 3600
        let minutes = (timeRemaining % 3600) / 60
        return String(format: "%02d시간 %02d분 남음", hours, minutes)
    }
    
    
    
    //MARK: -API 함수
    /// 오늘의 미션 로드 함수
    func loadTodayMission() {
        guard !isLoading else { return }
        isLoading = true
        
        print("loadTodayMission 요청 시작")

        container.useCaseService.missionServise.fetchTodayMission()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    print("미션 조회 실패: ", error)
                    self?.toast = CustomToast(
                        title: "미션 조회 실패",
                        message: error.errorDescription ?? "알 수 없는 에러"
                    )
                }
            } receiveValue: { [weak self] mission in
                print("미션 응답: ", mission)
                self?.missionContent = mission.contents
                self?.remainingSeconds = mission.remainingSeconds
                self?.restarted = mission.restarted
            }
            .store(in: &cancellables)
    }
    
    /// 미션 시작 함수
    func startMission() {
        guard !isLoading else { return }
        guard let missionId else { return }
        guard let uploadedImageUrl else { return }
        
        isLoading = true
        
        print("startMission 요청 시작")
        
        let request = MissionStartRequest(
            content: memo,
            imageUrl: uploadedImageUrl
        )

        container.useCaseService.missionServise
            .startMission(missionId: missionId, data: request)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    print("미션 시작 실패: ", error)
                    self?.toast = CustomToast(
                        title: "미션 시작 실패",
                        message: error.errorDescription ?? "알 수 없는 에러"
                    )
                }
            } receiveValue: { [weak self] result in
                print("미션 시작")
                self?.userMissionId = result.userMissionId
                self?.remainingSeconds = result.remainingSeconds
            }
            .store(in: &cancellables)
    }
    
    /// 미션 텍스트 제출 함수
    func saveDraftIfNeeded(text: String) {
        guard let userMissionId else { return }

        let request = MissionDraftRequest(contents: text)

        container.useCaseService.missionServise
            .saveMissionDraft(userMissionId: userMissionId, data: request)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("임시저장 실패:", error)
                    }
                },
                receiveValue: { result in
                    print("임시저장 여부:", result.drafted)
                }
            )
            .store(in: &cancellables)
    }
    
    /// 미션 제출 함수
    func completeMission() {
        guard let userMissionId else { return }
        isLoading = true

        container.useCaseService.missionServise
            .completeMission(userMissionId: userMissionId)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        print("미션 제출 실패:", error)
                    }
                },
                receiveValue: { [weak self] _ in
                    print("미션 제출 완료")
                }
            )
            .store(in: &cancellables)
    }
    
    /// 미션 새로고침 함수
     func restartTodayMission() {
         guard !isLoading else { return }
         isLoading = true
         
         container.useCaseService.missionServise
        .restartTodayMission()
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            if case .failure(let error) = completion {
                self?.toast = CustomToast(
                    title: "미션 새로고침 실패",
                    message: error.errorDescription ?? "알 수 없는 오류"
                )
            }
        } receiveValue: { [weak self] result in
            self?.currentMission = result.contents
            self?.remainingSeconds = result.remainingSeconds
            self?.restarted = result.restarted
        }
        .store(in: &cancellables)
}
}
