//
//  MissionViewModel.swift
//  Symteo
//
//  Created by 박병선 on 1/7/26.
//
import Foundation
import SwiftUI
import Combine

@MainActor
final class MissionViewModel: ObservableObject {

    // 흐름 상태
    @Published var uiState: MissionState = .arrived

    // 입력 데이터
    @Published var selectedImages: [UIImage] = []
    @Published var memo: String = ""

    // 파생 상태
    var canSubmit: Bool {
        !selectedImages.isEmpty
    }
    
    @Published var refreshCount: Int = 0
    @Published var timeRemaining: Int = 0
    @Published var currentMission: String = ""
    private var timer: AnyCancellable?

        init() {
            // 초기 데이터 로드 및 타이머 시작
            updateRemainingTime()
            startTimer()
            Task { await fetchMission() }
        }

        @MainActor
        func fetchMission() async {
            // TODO: 나중에 실제 API 통신 (현재는 더미 데이터)
            self.currentMission = "오늘 하늘 색은 무슨 색인가요?\n사진을 찍어 남겨보세요"
        }

        func updateRemainingTime() {
            let now = Date()
            let calendar = Calendar.current
            
            // 오늘 날짜의 다음 날 00시 00분 00초 (자정) 계산
            guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: now),
                  let nextMidnight = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: tomorrow) else {
                return
            }
            
            self.timeRemaining = Int(nextMidnight.timeIntervalSince(now))
        }

        func startTimer() {
            timer?.cancel()
            timer = Timer.publish(every: 1, on: .main, in: .common)
                .autoconnect()
                .sink { [weak self] _ in
                    guard let self = self else { return }
                    if self.timeRemaining > 0 {
                        self.timeRemaining -= 1
                    } else {
                        // 자정이 되면 미션 자동 리셋
                        self.updateRemainingTime()
                        Task { await self.fetchMission() }
                    }
                }
        }

        // 새로운 UI 포맷: "08시간 30분 남음"
        func timeRemainingString() -> String {
            let hours = timeRemaining / 3600
            let minutes = (timeRemaining % 3600) / 60
            return String(format: "%02d시간 %02d분 남음", hours, minutes)
        }
}
