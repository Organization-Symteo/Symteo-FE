//
//  NicknameViewModel.swift
//  Symteo
//

import Foundation
import Combine

@MainActor
final class NicknameViewModel: ObservableObject {

    @Published var nickname: String = ""
    @Published var isDuplicated: Bool? = nil
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false

    private let sessionManager: SessionManager
    private let userService: UserServicing
    private let tokenProvider: TokenProviding
    private var cancellables = Set<AnyCancellable>()

    init(
        sessionManager: SessionManager,
        userService: UserServicing = UserService(),
        tokenProvider: TokenProviding = TokenProvider()
    ) {
        self.sessionManager = sessionManager
        self.userService = userService
        self.tokenProvider = tokenProvider
    }

    func checkNickname() {
        guard let accessToken = tokenProvider.accessToken, !accessToken.isEmpty else {
            errorMessage = "인증이 필요합니다."
            return
        }

        isLoading = true
        errorMessage = nil
        isDuplicated = nil

        userService.checkNickname(accessToken: accessToken, nickname: nickname)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] result in
                self?.isDuplicated = result.isDuplicated
            }
            .store(in: &cancellables)
    }

    func signup() {
        guard let accessToken = tokenProvider.accessToken, !accessToken.isEmpty else {
            errorMessage = "인증이 필요합니다."
            return
        }

        isLoading = true
        errorMessage = nil

        userService.signup(accessToken: accessToken, nickname: nickname)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] result in
                guard let self else { return }
                self.sessionManager.applySocialLoginResult(
                    accessToken: result.accessToken,
                    refreshToken: result.refreshToken,
                    userId: result.userId,
                    isRegistered: result.registered,
                    nickname: result.nickname
                )
            }
            .store(in: &cancellables)
    }
}
