//
//  EmotionWeather.swift
//  Symteo
//
//  Created by 박병선 on 1/13/26.
//  오늘의 날씨를 나타내는 Enum 입니다.
import Foundation


enum EmotionWeather: String, CaseIterable, Identifiable {
    case sunny          // 맑음
    case cloudy         // 흐림
    case rainy          // 비
    case lightening    // 번개

    var id: String { rawValue }

    // 이미지 이름 매핑
    var normalImage: String {
        "\(rawValue)_normal"
    }

    var selectedImage: String {
        "\(rawValue)_selected"
    }

    var disabledImage: String {
        "\(rawValue)_disabled"
    }
    
    // MARK: - 로직 추가: 현재 상태에 맞는 이미지 이름 반환
        func getImageName(isSelected: Bool, isAnySelected: Bool) -> String {
            if isSelected {
                return selectedImage
            } else if isAnySelected {
                return disabledImage
            } else {
                return normalImage
            }
        }
}
