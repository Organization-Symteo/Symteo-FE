//
//  HomeViewModel.swift
//  Symteo
//
//  Created by 박병선 on 1/7/26.
//
import Foundation
import SwiftUI
import Combine

final class HomeViewModel: ObservableObject {

    // MARK: - Toast
    /// 홈 화면에서 사용하는 공통 토스트 상태
    @Published var toast: CustomToast? = nil

    // MARK: - Dependency Injection & Combine
    
    /// DIContainer를 통한 의존성 주입
    let container: DIContainer
    
    /// Combine 구독 해제를 관리하기 위한 cancellables
    var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    /// HomeViewModel 초기화
    /// - Parameter container: 의존성이 주입된 DIContainer
    init(container: DIContainer) {
        self.container = container
    }

    // MARK: - State
    /// 사용자 닉네임
    @Published var nickname: String = ""
    
    /// 오늘의 한 줄 문구
    @Published var todayLine: String = ""
    
    /// 선택된 오늘의 감정 날씨
    @Published var selectedWeather: EmotionWeather? = nil
    
    /// 홈 화면 로딩 상태
    @Published var isLoading: Bool = false

    // MARK: - API: Update Today Weather
    /// 오늘의 감정 날씨를 수정하는 API 호출
    /// - Parameter weather: 사용자가 선택한 감정 날씨
    ///
    /// 성공 시:
    /// - selectedWeather 상태 업데이트
    ///
    /// 실패 시:
    /// - 에러 메시지를 담은 토스트 표시
    func updateTodayWeather(_ weather: EmotionWeather) {
        selectedWeather = weather
        
        container.useCaseService.homeService
            .updateTodayWeather(weather: weather.rawValue)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.toast = CustomToast(
                        title: "감정 날씨 수정 실패",
                        message: error.errorDescription ?? "알 수 없는 오류"
                    )
                }
            } receiveValue: { [weak self] _ in
                self?.selectedWeather = weather
            }
            .store(in: &cancellables)
    }

    // MARK: - API: Fetch Home
    /// 홈 화면에 필요한 전체 데이터를 조회하는 API 호출
    ///
    /// 조회 항목:
    /// - 사용자 닉네임
    /// - 오늘의 한 줄 문구
    /// - 오늘의 감정 날씨
    ///
    /// 중복 호출을 방지하기 위해 isLoading 상태를 체크
    func loadHome() {
        guard !isLoading else { return }
        isLoading = true

        container.useCaseService.homeService
            .fetchHome()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    print("홈 조회 실패:", error)
                    self?.isLoading = false
                }
            } receiveValue: { [weak self] result in
                self?.nickname = result.nickname
                self?.todayLine = result.todayLine
                self?.selectedWeather = EmotionWeather(rawValue: result.todayWeather)
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
}
