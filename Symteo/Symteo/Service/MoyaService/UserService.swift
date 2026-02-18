//
//  UserService.swift
//  Symteo
//

import Foundation
import Combine
import Moya

protocol UserServicing {
    func checkNickname(accessToken: String, nickname: String) -> AnyPublisher<UserNicknameCheckResultDTO, APIError>
    func signup(accessToken: String, nickname: String) -> AnyPublisher<UserSignupResultDTO, APIError>
}

final class UserService: UserServicing {

    private let provider: MoyaProvider<UserRouter>

    init(provider: MoyaProvider<UserRouter> = APIManager.shared.createProvider(for: UserRouter.self)) {
        self.provider = provider
    }

    func checkNickname(accessToken: String, nickname: String) -> AnyPublisher<UserNicknameCheckResultDTO, APIError> {
        provider.requestResult(.checkNickname(accessToken: accessToken, nickname: nickname), type: UserNicknameCheckResultDTO.self)
    }

    func signup(accessToken: String, nickname: String) -> AnyPublisher<UserSignupResultDTO, APIError> {
        provider.requestResult(.signup(accessToken: accessToken, dto: .init(nickname: nickname)), type: UserSignupResultDTO.self)
    }
}

