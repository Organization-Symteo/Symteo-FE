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
    /// 미션 화면 전반에서 사용하는 공통 토스트
    @Published var toast: CustomToast? = nil

    // MARK: - UI Flow State
    /// 미션 화면의 전체 흐름 상태 (도착 → 확인 → 수행 → 완료)
    @Published var uiState: MissionState = .arrived

    // MARK: - User Input
    /// 사용자가 선택한 이미지 목록
    @Published var selectedImages: [UIImage] = []
    
    /// 미션 수행 중 입력한 메모 텍스트
    @Published var memo: String = ""

    // MARK: - Mission Identifiers & Status
    /// 서버에서 발급받은 사용자 미션 ID (미션 수행 이후 사용)
    @Published var userMissionId: Int?
    
    /// API 요청 중 여부를 나타내는 로딩 상태
    @Published var isLoading: Bool = false
    
    /// 오늘의 미션 내용 (텍스트)
    @Published var missionContent: String = ""
    
    /// 서버 기준으로 내려오는 미션 남은 시간 (초 단위)
    @Published var remainingSeconds: Int = 0
    
    /// 미션 새로고침 가능 여부
    @Published var restarted: Bool = false
    
    /// 오늘의 미션 고유 ID (미션 시작 API 호출 시 사용)
    @Published var missionId: Int?
    
    /// Presigned URL 업로드 후 서버에 전달할 이미지 URL
    @Published var uploadedImageUrl: String?
    
    /// 에러 메시지 저장용 상태 (디버깅 / UI 확장 대비)
    @Published var errorMessage: String?
    
    /// 미션 새로고침 횟수
    @Published var refreshCount: Int = 0
    
    /// 타이머에서 감소시키는 남은 시간 (초 단위)
    @Published var timeRemaining: Int = 0
    
    /// 현재 미션 내용 (새로고침 이후 사용)
    @Published var currentMission: String = ""
    
    /// 1초 단위 타이머 관리용 Combine 객체
    private var timer: AnyCancellable?
    
    /// 서버가 내려준 종료 시각 (초 단위 timestamp)
    private var endTimestamp: TimeInterval = 0

    // MARK: - Dependency Injection & Combine
    /// DIContainer를 통한 의존성 주입
    let container: DIContainer
    
    /// Combine 구독 해제를 관리하기 위한 cancellables
    var cancellables = Set<AnyCancellable>()
    private var draftCancellable: AnyCancellable?

    // MARK: - Init
    /// MissionViewModel 초기화
    /// - Parameter container: 의존성이 주입된 DIContainer
    init(container: DIContainer) {
        self.container = container
        bindDraftAutoSave()
    }

    /// 유저가 타이핑 멈춘 후 saveDraftIfNeeded 한 번만 호출하도록
    private func bindDraftAutoSave() {
        draftCancellable = $memo
            .debounce(for: .milliseconds(400), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                guard let self else { return }
                self.saveDraftIfNeeded(text: text)
            }
    }
    // MARK: - Timer
    /// 서버에서 내려준 remainingSeconds 값을 기준으로
    /// 1초마다 timeRemaining을 감소시키는 타이머 시작
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
    
    // MARK: - 미션 새로 고침 시 카운트 증가시키는 함수
    func refreshMission() {
        refreshCount += 1
    }

    // MARK: - Time Formatter
    /// 남은 시간을 "00시간 00분 남음" 형식의 문자열로 변환
    func timeRemainingString() -> String {
        let safeTime = max(timeRemaining, 0)

        let hours = safeTime / 3600
        let minutes = (safeTime % 3600) / 60

        return String(format: "%02d시간 %02d분 남음", hours, minutes)
    }
    

    
    func goBackToArrived() {
        uiState = .arrived
    }

    // MARK: - API: Fetch Today Mission
    /// 오늘의 미션 정보를 조회하는 API 호출
    ///
    /// 조회 항목:
    /// - 미션 내용
    /// - 남은 시간
    /// - 새로고침 가능 여부
    func loadTodayMission() {
        guard !isLoading else { return }
        isLoading = true

        print("loadTodayMission 요청 시작")

        container.useCaseService.missionServise
            .fetchTodayMission()
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
                guard let self else { return }

                print("🔥 remainingSeconds raw:", mission.remainingSeconds)
                self.missionId = mission.missionId
                self.userMissionId = mission.userMissionId
                self.missionContent = mission.contents
                self.restarted = mission.restarted
                self.timeRemaining = mission.remainingSeconds

                startTimer()

                self.uiState = .confirmed
            }
            .store(in: &cancellables)
    }

    // MARK: - API: Start Mission
    /// 미션을 시작하는 API 호출
    ///
    /// 필요 조건:
    /// - missionId 존재
    /// - 업로드된 이미지 URL 존재
    ///
    func startMission() {
        
        print("🧡 startMission 요청 시작")
        print("missionId:", missionId as Any)
        print("uploadedImageUrl:", uploadedImageUrl as Any)

        guard !isLoading else { return }

        guard let missionId else {
            print("❌ missionId is nil")
            return
        }

        guard let uploadedImageUrl else {
            print("❌ uploadedImageUrl is nil")
            return
        }

        isLoading = true

    
        let request = MissionStartRequest(
            contents: memo,
            imageUrl: uploadedImageUrl // optional 그대로 전달
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
                self?.uiState = .writing
        
            }
            .store(in: &cancellables)
    }
     

    // MARK: - API: Save Draft
    /// 미션 수행 중 입력한 텍스트를 임시 저장하는 API 호출
    /// - Parameter text: 현재 입력 중인 미션 텍스트
    func saveDraftIfNeeded(text: String) {
        guard let userMissionId else { return }
        
        print("🧡 미션 임시저장 함수 요청")
   
        
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

    // MARK: - API: Complete Mission
    /// 미션을 최종 제출하는 API 호출
    func completeMission() {
        guard let userMissionId else { return }
        isLoading = true

        print("🧡 미션 제출 함수 요청")
        container.useCaseService.missionServise.completeMission(userMissionId: userMissionId)
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
                    self?.uiState = .completed   
                }
            )
            .store(in: &cancellables)
    }

    // MARK: - API: Restart Today Mission
    /// 오늘의 미션을 새로고침하는 API 호출
    func restartTodayMission() {
        guard !isLoading else { return }
        isLoading = true

        print("🧡 미션 새로고침 함수 요청")

        container.useCaseService.missionServise
            .restartTodayMission()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                
                if case .failure(let error) = completion {
                    self?.toast = CustomToast(
                        title: "미션 새로고침 실패",
                        message: error.errorDescription ?? "알 수 없는 오류"
                    )
                }
            } receiveValue: { [weak self] result in
                guard let self else { return }

                //  새 미션 내용
                self.missionContent = result.contents

                //  새로고침 횟수 증가
                self.refreshCount += 1

                //  남은 시간은 그냥 초 그대로
                self.timeRemaining = result.remainingSeconds

                //  타이머 재시작
                self.startTimer()

                self.restarted = result.restarted
            }
            .store(in: &cancellables)
    }
}

