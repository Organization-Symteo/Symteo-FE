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
    @AppStorage("session_userId") private var storedUserId: Int = 0
    @AppStorage("session_nickname") private var storedNickname: String = ""
    @AppStorage("session_isRegistered") private var storedIsRegistered: Bool = false
    @AppStorage("session_counselorConfigured") private var storedCounselorConfigured: Bool = false

    @Published var userId: Int? = nil
    @Published var nickname: String? = nil
    @Published var isRegistered: Bool = false
    @Published var counselorConfigured: Bool = false

    private(set) var accessToken: String? = nil
    private(set) var refreshToken: String? = nil

    private let keychain: KeychainService
    private let authAccountService: AuthAccountServicing

    init(
        keychain: KeychainService,
        authAccountService: AuthAccountServicing = AuthAccountService()
    ) {
        self.keychain = keychain
        self.authAccountService = authAccountService
    }
    

    
    var userName: String {
        nickname ?? ""
    }

    func bootstrap() async {
        if !didFinishOnboarding {
            flow = .onboarding
            return
        }

        if let token = keychain.loadToken() {
            accessToken = token.accessToken
            refreshToken = token.refreshToken

            userId = (storedUserId == 0) ? nil : storedUserId
            nickname = storedNickname.isEmpty ? nil : storedNickname
            isRegistered = storedIsRegistered
            counselorConfigured = storedCounselorConfigured

            if let accessToken, let refreshToken, !accessToken.isEmpty, !refreshToken.isEmpty {
                do {
                    let refreshed = try await authAccountService.refresh(accessToken: accessToken, refreshToken: refreshToken)
                    applyRefreshedSession(
                        accessToken: refreshed.accessToken,
                        refreshToken: refreshed.refreshToken,
                        userId: refreshed.userId,
                        registered: refreshed.registered,
                        nickname: refreshed.nickname
                    )
                } catch {
                    logout()
                    return
                }
            }

            decideNextFlow()
        } else {
            flow = .loggedOut
        }
    }

    func finishOnboarding() {
        didFinishOnboarding = true
        flow = .loggedOut
    }

    func applySocialLoginResult(
        accessToken: String,
        refreshToken: String,
        userId: Int,
        isRegistered: Bool,
        nickname: String?
    ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.userId = userId
        self.isRegistered = isRegistered
        self.nickname = nickname

        storedUserId = userId
        storedIsRegistered = isRegistered
        storedNickname = nickname ?? ""

        keychain.saveToken(.init(accessToken: accessToken, refreshToken: refreshToken))
        decideNextFlow()
    }

    func applyNicknameSaved(_ nickname: String) {
        self.nickname = nickname
        self.isRegistered = true

        storedNickname = nickname
        storedIsRegistered = true
        decideNextFlow()
    }

    func applyCounselorConfigured() {
        counselorConfigured = true
        storedCounselorConfigured = true
        decideNextFlow()
    }

    func logout() {
        _ = keychain.deleteToken()

        accessToken = nil
        refreshToken = nil
        userId = nil
        nickname = nil
        isRegistered = false
        counselorConfigured = false

        storedUserId = 0
        storedNickname = ""
        storedIsRegistered = false
        storedCounselorConfigured = false

        flow = didFinishOnboarding ? .loggedOut : .onboarding
    }

    private func applyRefreshedSession(
        accessToken: String,
        refreshToken: String,
        userId: Int,
        registered: Bool,
        nickname: String?
    ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.userId = userId
        self.isRegistered = registered
        self.nickname = nickname

        storedUserId = userId
        storedIsRegistered = registered
        storedNickname = nickname ?? ""

        keychain.saveToken(.init(accessToken: accessToken, refreshToken: refreshToken))
    }

    private func decideNextFlow() {
        guard didFinishOnboarding else {
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
