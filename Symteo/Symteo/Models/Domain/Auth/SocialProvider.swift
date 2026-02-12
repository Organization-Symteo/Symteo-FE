//
//  SocialProvider.swift
//  Symteo
//
//  Created by 김지우 on 2/12/26.
//

import Foundation

enum SocialProvider: CaseIterable, Identifiable {
    
    case kakao
    case naver
    case google

    var id: String { title }

    var title: String {
        switch self {
        case .kakao: return "카카오로 시작하기"
        case .naver: return "네이버로 시작하기"
        case .google: return "구글로 시작하기"
        }
    }

    var icon: String {
        switch self {
        case .kakao: return "kakaologo"
        case .naver: return "naverlogo"
        case .google: return "googlelogo"
        }
    }
}
