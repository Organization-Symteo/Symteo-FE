//
//  SessionManager.swift
//  Symteo
//
//  Created by 김지우 on 1/12/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class SessionManager: ObservableObject {

    enum AppFlow: Equatable {
        case onboarding
        case loggedOut
        case needsNickname
        case needsCounselor
        case home
    }

    @Published var flow: AppFlow = .loggedOut

    @AppStorage("didFinishOnboarding") private var didFinishOnboarding: Bool = false

    @EnvironmentObject var container: DIContainer
    @Published var userId: Int? = nil
    @Published var nickname: String? = nil
    @Published var isRegistered: Bool = false
    @Published var counselorConfigured: Bool = false

    private(set) var accessToken: String? = nil
    private(set) var refreshToken: String? = nil

    private let keychain: KeychainService

    init(keychain: KeychainService) {
        self.keychain = keychain
    }

    func bootstrap() async {
        if !didFinishOnboarding {
            flow = .onboarding
            return
        }

        if let token = keychain.loadToken() {
            accessToken = token.accessToken
            refreshToken = token.refreshToken
            decideNextFlow()
        } else {
            flow = .loggedOut
        }
    }

    func finishOnboarding() {
        didFinishOnboarding = true
        flow = .loggedOut
    }

    func applySocialLoginResult(accessToken: String,
                               refreshToken: String,
                               userId: Int,
                               isRegistered: Bool,
                               nickname: String?) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.userId = userId
        self.isRegistered = isRegistered
        self.nickname = nickname

        keychain.saveToken(.init(accessToken: accessToken, refreshToken: refreshToken))
        decideNextFlow()
    }

    func applyNicknameSaved(_ nickname: String) {
        self.nickname = nickname
        self.isRegistered = true
        decideNextFlow()
    }

    func applyCounselorConfigured() {
        self.counselorConfigured = true
        decideNextFlow()
    }

    @MainActor
    func logout() {
        _ = keychain.deleteToken()
        accessToken = nil
        refreshToken = nil
        userId = nil
        nickname = nil
        isRegistered = false
        counselorConfigured = false
        flow = didFinishOnboarding ? .loggedOut : .onboarding
    }

    private func decideNextFlow() {
        guard didFinishOnboarding else {
            print("현재 flow: \(flow)")
            flow = .onboarding
            return
        }

        guard accessToken != nil, userId != nil else {
            flow = .loggedOut
            return
        }

        if !isRegistered || (nickname?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) {
            flow = .needsNickname
            return
        }

        if !counselorConfigured {
            flow = .needsCounselor
            return
        }

        flow = .home
    }

}
