//
//  WeatherButton.swift
//  Symteo
//
//  Created by 박병선 on 1/13/26.
//
import SwiftUI

struct WeatherButton: View {
    let weather: EmotionWeather
    let isSelected: Bool
    let isAnySelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(
                weather.getImageName(
                    isSelected: isSelected,
                    isAnySelected: isAnySelected
                )
            )
            .resizable()
            .frame(width: 64, height: 64)
        }
        .buttonStyle(.plain)
    }
}
