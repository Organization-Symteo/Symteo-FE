//
//  HomeService.swift
//  Symteo
//
//  Created by 박병선 on 2/1/26.
//
import Foundation
import Combine
import Moya
import CombineMoya

/// 홈 서비스 프로토콜
protocol HomeServiceProtocol {
    ///오늘의 감정날씨 수정
    func updateTodayWeather(weather: Int) -> AnyPublisher<Int, APIError>
    
    /// 홈 화면 전체 내용 조회
    func fetchHome() -> AnyPublisher<HomeResponse, APIError>
}

/// HomeAPI를 이용하는 서비스
final class HomeService: HomeServiceProtocol {
    
    /// MoyaProvider를 통해 API 요청 전송
    let provider: MoyaProvider<HomeRouter>
  
    init(provider: MoyaProvider<HomeRouter> = APIManager.shared.createProvider(for: HomeRouter.self)) {
        self.provider = provider
    }
    
    //MARK: -오늘의 감정날씨 수정
    func updateTodayWeather(weather: Int) -> AnyPublisher<Int, APIError> {
        provider.requestResult(.updateTodayWeather(weather: weather), type: Int.self)
    }
    
    //MARK: -홈 화면 전체 내용 조회
    func fetchHome() -> AnyPublisher<HomeResponse, APIError> {
           provider.requestResult(.fetchHome, type: HomeResponse.self)
       }
}
