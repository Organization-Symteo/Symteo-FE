//
//  EmotionWeather.swift
//  Symteo
//
//  Created by 박병선 on 1/13/26.
//  오늘의 날씨를 나타내는 Enum 입니다.
import Foundation

enum EmotionWeather: Int, CaseIterable, Identifiable {
    case sunny = 1        // 맑음
    case cloudy = 2       // 구름
    case lightening = 3   // 번개
    case rainy = 4        // 비
    
    var id: Int { rawValue }
    
    private var assetKey: String {
        switch self {
        case .sunny: return "sunny"
        case .cloudy: return "cloudy"
        case .lightening: return "lightening"
        case .rainy: return "rainy"
        }
    }
    
    
    var normalImage: String { "\(assetKey)_normal" }
    var selectedImage: String { "\(assetKey)_selected" }
    var disabledImage: String { "\(assetKey)_disabled" }
    
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

