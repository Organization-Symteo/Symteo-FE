//
//  RecommendationType.swift
//  Symteo
//
//  Created by 박병선 on 1/13/26.
//  홈화면에서 우울&불안 검사, 스트레스 검사, 성향 검사 화면 전환을 구현하기 위한 Enum입니다.
import Foundation

enum RecommendationType: Hashable {
    case anxiety   // 우울·불안
    case stress       // 스트레스
    case attachment // 성향
}
