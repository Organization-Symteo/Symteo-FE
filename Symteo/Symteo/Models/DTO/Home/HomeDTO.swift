//
//  HomeDTO.swift
//  Symteo
//
//  Created by 박병선 on 2/3/26.
//
import Foundation

/// 오늘의 감정날씨 Response
struct TodayWeatherResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: Int
}

/// 홈 화면 전체 내용 조회 Response
struct HomeResponse: Codable {
    let todayLine: String
    let todayWeather: Int
    let nickname: String
}
