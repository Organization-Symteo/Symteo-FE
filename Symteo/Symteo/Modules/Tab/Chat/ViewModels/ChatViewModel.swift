//
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

    @Published var showNoReportModal: Bool = false
    @Published var noReportModalTitle: String = "저장된 리포트가 없습니다."
    @Published var noReportModalMessage: String = "진단하러 가시겠습니까?"
    @Published var pendingDiagnosisDestination: NavigationDestination? = nil

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

    var todayDateText: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.dateFormat = "yyyy년 M월 d일 EEEE"
        return formatter.string(from: Date())
    }

    var currentTime: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date())
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
                    self.handleLoadReportError(err, reportType: reportType)
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

    private func handleLoadReportError(_ error: APIError, reportType: String) {
        switch error {
        case let .serverError(code, message):
            if code == "REPORTS404" || code == "REPORT404" {
                pendingDiagnosisDestination = Self.diagnosisDestination(for: reportType)
                showNoReportModal = true
                return
            }

            if code == "CHATROOM404" {
                alertMessage = "\(code): \(message)"
                return
            }

            alertMessage = "\(code): \(message)"

        default:
            alertMessage = "네트워크 오류가 발생했습니다."
        }
    }

    static func diagnosisDestination(for reportType: String) -> NavigationDestination? {
        switch reportType {
        case "DEPRESSION_ANXIETY_COMPLEX":
            return .depressionTest
        case "STRESS_BURNOUT_COMPLEX":
            return .stressTest
        case "ATTACHMENT_TEST":
            return .typeTest
        default:
            return nil
        }
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

    func clearNoReportModal() {
        showNoReportModal = false
        pendingDiagnosisDestination = nil
    }
}
