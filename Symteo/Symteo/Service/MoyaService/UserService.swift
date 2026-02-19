//
//  UserService.swift
//  Symteo
//
import Foundation
import Combine
import Moya
import CombineMoya

protocol UserServicing {
    func checkNickname(_ nickname: String) -> AnyPublisher<CheckNicknameResultDTO, APIError>
    func signupNickname(_ nickname: String) -> AnyPublisher<SignupNicknameResponseDTO, APIError>
    func updateNickname(_ nickname: String) -> AnyPublisher<UpdateNicknameResultDTO, APIError>
}

final class UserService: UserServicing {

    private let provider: MoyaProvider<UserRouter>

    init(provider: MoyaProvider<UserRouter> = APIManager.shared.createProvider(for: UserRouter.self)) {
        self.provider = provider
    }

    func checkNickname(_ nickname: String) -> AnyPublisher<CheckNicknameResultDTO, APIError> {
        provider.requestResult(.checkNickname(nickname: nickname), type: CheckNicknameResultDTO.self)
    }

    func updateNickname(_ nickname: String) -> AnyPublisher<UpdateNicknameResultDTO, APIError> {
        provider.requestResult(.updateNickname(request: NicknameRequestDTO(nickname: nickname)), type: UpdateNicknameResultDTO.self)
    }

    
    func signupNickname(_ nickname: String) -> AnyPublisher<SignupNicknameResponseDTO, APIError> {
        provider.requestPublisher(.signup(request: NicknameRequestDTO(nickname: nickname)))
            .map(SignupNicknameResponseDTO.self)
            .mapError { moyaError in
                // Convert MoyaError to your domain-specific APIError to match the method's return type
                if let apiError = moyaError as? APIError {
                    return apiError
                }
                return APIError.unknown
            }
            .eraseToAnyPublisher()
    }
}

