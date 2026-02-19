//
//  ChatService.swift
//  Symteo
//
//  Created by 김지우 on 2/11/26.
//

import Foundation
import Combine
import Moya

protocol CounselServicing {
    func upsertSetting(_ request: CounselSettingRequestDTO) -> AnyPublisher<CounselSettingResultDTO, APIError>
    func fetchSetting() -> AnyPublisher<CounselSettingResultDTO, APIError>

    func sendMessage(chatRoomId: Int?, text: String) -> AnyPublisher<CounselSendResultDTO, APIError>
    func endChat(chatRoomId: Int) -> AnyPublisher<CounselEndResultDTO, APIError>

    func fetchReport(chatRoomId: Int?, reportType: String, reportId: Int) -> AnyPublisher<CounselReportResultDTO, APIError>
}

final class CounselService: CounselServicing {

    private let provider: MoyaProvider<ChatRouter>

    init(provider: MoyaProvider<ChatRouter> = APIManager.shared.createProvider(for: ChatRouter.self)) {
        self.provider = provider
    }

    func upsertSetting(_ request: CounselSettingRequestDTO) -> AnyPublisher<CounselSettingResultDTO, APIError> {
        provider.requestResult(.upsertSetting(request: request), type: CounselSettingResultDTO.self)
    }

    func fetchSetting() -> AnyPublisher<CounselSettingResultDTO, APIError> {
        provider.requestResult(.fetchSetting, type: CounselSettingResultDTO.self)
    }

    func sendMessage(chatRoomId: Int?, text: String) -> AnyPublisher<CounselSendResultDTO, APIError> {
        var body: [String: Any] = ["text": text]
        body["chatRoomId"] = chatRoomId.map { $0 } ?? NSNull()
        return provider.requestResult(.sendMessage(body: body), type: CounselSendResultDTO.self)
    }

    func endChat(chatRoomId: Int) -> AnyPublisher<CounselEndResultDTO, APIError> {
        provider.requestResult(
            .endChat(request: .init(chatRoomId: Int64(chatRoomId))),
            type: CounselEndResultDTO.self
        )
    }

    func fetchReport(chatRoomId: Int?, reportType: String, reportId: Int) -> AnyPublisher<CounselReportResultDTO, APIError> {
        let request = CounselReportRequestDTO(
            chatRoomId: chatRoomId,
            reportType: reportType,
            reportId: reportId
        )
        return provider.requestResult(
            .fetchReport(request: request),
            type: CounselReportResultDTO.self
        )
    }
}
