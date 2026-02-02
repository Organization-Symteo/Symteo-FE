//
//  RecommendationItem.swift
//  Symteo
//
//  Created by 박병선 on 1/13/26.
//  RecommadationType(추천 검사)에 따른 이미지를 View에 전달하기 위한 모델입니다.

import Foundation

struct RecommendationItem: Identifiable {
    let id = UUID()
    let imageName: String
    let type: RecommendationType
}
