//
//  LoginViewModel.swift
//  Symteo
//
//  Created by 김지우 on 1/12/26.
//

import Foundation
import Combine

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

@MainActor
final class LoginViewModel: ObservableObject {

    let providers: [SocialProvider] = SocialProvider.allCases

    func tapLogin(provider: SocialProvider) {
        switch provider {
        case .kakao:
            loginWithKakao()
        case .naver:
            loginWithNaver()
        case .google:
            loginWithGoogle()
        }
    }

    private func loginWithKakao() {
        print("카카오 로그인")
        // TODO: Kakao SDK
    }

    private func loginWithNaver() {
        print("네이버 로그인")
        // TODO: Naver SDK
    }

    private func loginWithGoogle() {
        print("구글 로그인")
        // TODO: Google SDK
    }
}
