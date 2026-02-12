//
//  LoginNavigationView.swift
//  Symteo
//
//  Created by 김지우 on 2/5/26.
//
import SwiftUI

struct LoginNavigationView: View {
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var sessionManager: SessionManager
    @StateObject private var loginRouter: LoginRouter = .init()

    var body: some View {
        NavigationStack(path: $loginRouter.path) {
            
            LoginView(sessionManager: sessionManager, loginRouter: loginRouter)
                .navigationDestination(for: LoginDestination.self) { route in
                    switch route {
                    case .permit:
                        Text("권한 안내")
                    case .policy(let num):
                        Text("약관 상세 \(num)")
                    case .nickname:
                        NicknameEditView()
                    }
                }
        }
        .environmentObject(loginRouter)
    }
}
