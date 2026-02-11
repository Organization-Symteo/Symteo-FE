//
//  TestService.swift
//  Symteo
//
//  Created by 김지우 on 2/10/26.
//


import Foundation
import Combine
import Moya
import Alamofire

protocol TestServiceProtocol {
    func createTest(_ request: CreateTestRequestDTO) -> AnyPublisher<CreateTestResponseDTO, APIError>
}

@MainActor
final class TestService: TestServiceProtocol {

    private let provider: MoyaProvider<TestRouter>

    init(provider: MoyaProvider<TestRouter> = APIManager.shared.createProvider(for: TestRouter.self)) {
        self.provider = provider
    }

    convenience init(stubbed: Bool) {
        if stubbed {
            let provider = MoyaProvider<TestRouter>(stubClosure: MoyaProvider.immediatelyStub)
            self.init(provider: provider)
        } else {
            self.init()
        }
    }

    func createTest(_ request: CreateTestRequestDTO) -> AnyPublisher<CreateTestResponseDTO, APIError> {
        provider.requestResult(.createTest(request: request), type: CreateTestResponseDTO.self)
    }
}

