//
//  HomeViewModel.swift
//  Symteo
//
//  Created by 박병선 on 1/7/26.
//
import Foundation
import SwiftUI
import Combine

final class HomeViewModel:ObservableObject {
    // MARK: - Toast
    @Published var toast: CustomToast? = nil
    
    // MARK: - 의존성 주입 및 비동기 처리
    /// DIContainer를 통해 의존성 주입
    let container: DIContainer
    /// Combine 구독 해제를 위한 Set
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - 초기화
    init(container: DIContainer) {
        self.container = container
    }
    
    /// 상태변수
    @Published var nickname: String = ""
    @Published var todayLine: String = ""
    @Published var selectedWeather: EmotionWeather? = nil
    @Published var isLoading: Bool = false
    
    /// 오늘의 감정 날씨 수정
    func updateTodayWeather(_ weather: EmotionWeather) {
        container.useCaseService.homeService.updateTodayWeather(weather: weather.rawValue)
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
    
    /// 홈 화면 전체 내용 조회
    func loadHome() {
        guard !isLoading else { return }
           isLoading = true
        
        container.useCaseService.homeService.fetchHome()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("홈 조회 실패:", error)
                }
            } receiveValue: { [weak self] result in
                self?.nickname = result.nickname
                self?.todayLine = result.todayLine
                self?.selectedWeather = EmotionWeather(rawValue: result.todayWeather)
            }
            .store(in: &cancellables)
    }
}
