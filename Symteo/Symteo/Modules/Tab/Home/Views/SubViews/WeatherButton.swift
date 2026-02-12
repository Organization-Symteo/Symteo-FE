//
//  WeatherButton.swift
//  Symteo
//
//  Created by 박병선 on 1/13/26.
//
import SwiftUI

struct WeatherButton:  View {
    let weather: EmotionWeather
    let isSelected: Bool
    let isAnySelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            // 복잡한 이미지 이름 결정 로직을 컴파일러가 계산하기 쉽게 분리
            Image(weather.getImageName(
                isSelected: isSelected,
                isAnySelected: isAnySelected
            ))
            .resizable()
            .frame(width: 64, height: 64)
        }
        .buttonStyle(.plain) // 버튼 클릭 시 깜빡임 방지
    }
}
