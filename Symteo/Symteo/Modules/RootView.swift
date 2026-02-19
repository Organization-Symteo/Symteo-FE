//
//  RootView.swift
//  Symteo
//
//  Created by 김지우 on 1/12/26.
//

///앱의 첫 진입 지점에서, 스플래시 → 로그인 여부 판단 → 메인 플로우 연결 → 전역 상태 주입 → 데이터 수명 관리까지 총괄하는 앱 흐름 관리 뷰
///시뮬레이터 돌릴 때 사용
import SwiftUI

struct RootView: View {

    @AppStorage("lastResetDate") private var lastResetDate: Date?

    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var sessionManager: SessionManager

    @State private var showSplash = true

    var body: some View {
        ZStack {
            if showSplash {
                SplashView()
                    .transition(.opacity)
            } else {
                switch sessionManager.flow {
                case .onboarding:
                    OnboardingView()
                case .loggedOut:
                    LoginNavigationView()
                case .needsNickname:
                    NicknameEditView()
                case .needsCounselor:
                    CounselSettingView(usage: .onboarding)
                case .home:
                    NavigationRoutingView()
                }
            }
        }
        .environmentObject(container)
        .environmentObject(sessionManager)
        .task {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            withAnimation(.easeInOut(duration: 0.25)) { showSplash = false }
            await sessionManager.bootstrap()
        }
    }
}
