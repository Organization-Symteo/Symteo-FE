//  ChatViewModel.swift
//  Symteo
//
//  Created by 김지우 on 1/12/26.
//

import Foundation
import Combine
import SwiftUI
import Moya

@MainActor
final class ChatViewModel: ObservableObject {

    @Published var messages: [ChatMessage] = []
    @Published var textInput: String = ""
    @Published var isSending: Bool = false

    @Published var shouldScrollToBottom: Bool = false

    @Published var isShowingEndPopup: Bool = false
    @Published var isEnding: Bool = false
    @Published var endSummary: CounselEndResultDTO? = nil

    @Published var alertMessage: String? = nil

    @Published private(set) var isChatStarted: Bool = false
    @Published var isLoadingReport: Bool = false

    private let service: CounselServicing
    private var cancellables = Set<AnyCancellable>()

    @AppStorage("chatRoomId") private var storedChatRoomId: Int = 0
    private var chatRoomId: Int? {
        get { storedChatRoomId == 0 ? nil : storedChatRoomId }
        set { storedChatRoomId = newValue ?? 0 }
    }

    init() {
        let provider = APIManager.shared.createProvider(for: ChatRouter.self)
        self.service = CounselService(provider: provider)
    }

    func onAppearIfNeeded() {
        if messages.isEmpty {
            isChatStarted = false
            messages = [
                .model("안녕하세요! 저는 맞춤형 상담 AI ○○○이에요."),
                .model("아래에서 선택하시면 해당하는 서비스를 이용하실 수 있어요.")
            ]
            shouldScrollToBottom.toggle()
        }
    }

    func sendMessage() {
        let text = textInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        guard !isSending else { return }

        isChatStarted = true

        textInput = ""
        messages.append(.user(text))
        shouldScrollToBottom.toggle()

        isSending = true

        service.sendMessage(chatRoomId: chatRoomId, text: text)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isSending = false
                if case let .failure(err) = completion {
                    self.handleSendError(err)
                }
            } receiveValue: { [weak self] dto in
                guard let self else { return }
                self.chatRoomId = dto.chatRoomId
                self.messages.append(.model(dto.AiResponse))
                self.shouldScrollToBottom.toggle()
            }
            .store(in: &cancellables)
    }

    func loadReport(buttonTitle: String, reportType: String, reportId: Int = 0) {
        guard !isLoadingReport else { return }

        isChatStarted = true
        isLoadingReport = true

        messages.append(.user(buttonTitle))
        messages.append(.model("불러오는 중..."))
        shouldScrollToBottom.toggle()

        service.fetchReport(chatRoomId: chatRoomId, reportType: reportType, reportId: reportId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoadingReport = false

                if case let .failure(err) = completion {
                    if self.isLastLoadingBubble {
                        self.messages.removeLast()
                    }
                    self.alertMessage = self.describe(err)
                }
            } receiveValue: { [weak self] dto in
                guard let self else { return }
                self.chatRoomId = dto.chatRoomId

                if self.isLastLoadingBubble {
                    self.messages.removeLast()
                }
                self.messages.append(.model(dto.AiResponse))
                self.shouldScrollToBottom.toggle()
            }
            .store(in: &cancellables)
    }

    private var isLastLoadingBubble: Bool {
        guard let last = messages.last else { return false }
        return last.role == .model && last.content == "불러오는 중..."
    }

    func tapEndIcon() { isShowingEndPopup = true }
    func cancelEnd() { isShowingEndPopup = false }

    func confirmEnd() {
        isShowingEndPopup = false
        endChat()
    }

    private func endChat() {
        guard let chatRoomId else { return }
        guard !isEnding else { return }

        isEnding = true

        service.endChat(chatRoomId: chatRoomId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isEnding = false
                if case let .failure(err) = completion {
                    self.alertMessage = self.describe(err)
                }
            } receiveValue: { [weak self] summary in
                guard let self else { return }
                self.endSummary = summary

                self.chatRoomId = nil
                self.messages.removeAll()
                self.onAppearIfNeeded()
            }
            .store(in: &cancellables)
    }

    private func handleSendError(_ error: APIError) {
        switch error {
        case let .serverError(code, message):
            if code == "SETTING404" {
                alertMessage = "상담사 설정이 필요합니다. 설정에서 저장 후 다시 시도해 주세요."
            } else {
                alertMessage = "\(code): \(message)"
            }
        default:
            alertMessage = "네트워크 오류가 발생했습니다."
        }
    }

    private func describe(_ error: APIError) -> String {
        switch error {
        case let .serverError(code, message):
            return "\(code): \(message)"
        default:
            return "네트워크 오류가 발생했습니다."
        }
    }

    func clearAlert() {
        alertMessage = nil
    }
}
