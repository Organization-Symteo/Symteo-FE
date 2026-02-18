//
//  CounselSettingViewModel.swift
//  Symteo
//
//  Created by 김지우 on 2/5/26.
//

import Foundation
import SwiftUI
import Combine
import Moya

@MainActor
final class CounselSettingViewModel: ObservableObject {

    @Published var sections: [CounselSection] = [
        CounselSection(title: "대화 분위기", options: ["친근함", "따뜻함", "차분함"], isMultiSelect: true),
        CounselSection(title: "도움방식", options: ["공감 & 경청형", "해결 & 조언형", "팩트형"], isMultiSelect: true),
        CounselSection(title: "역할", options: ["상담사", "친구", "멘탈 코치"], isMultiSelect: true),
        CounselSection(title: "답변형식", options: ["짧고 간결", "길고 자세히", "상황에 맞게"], isMultiSelect: true),
        CounselSection(title: "말투", options: ["존댓말", "반말"], isMultiSelect: false)
    ]

    @Published var selections: [String: [String]] = [
        "대화 분위기": ["친근함"],
        "도움방식": ["공감 & 경청형"],
        "역할": ["상담사"],
        "답변형식": ["짧고 간결"],
        "말투": ["존댓말"]
    ]

    @Published var isSaving: Bool = false
    @Published var alertMessage: String? = nil

    private let service: CounselServicing
    private var cancellables = Set<AnyCancellable>()

    init() {
        let provider = APIManager.shared.createProvider(for: ChatRouter.self)
        self.service = CounselService(provider: provider)
    }

    func toggleOption(sectionTitle: String, option: String, isMultiSelect: Bool) {
        var current = selections[sectionTitle] ?? []

        if isMultiSelect {
            if let idx = current.firstIndex(of: option) {
                current.remove(at: idx)
            } else {
                current.append(option) // 마지막 선택을 맨 뒤로
            }
        } else {
            current = [option]
        }

        selections[sectionTitle] = current
    }

    func isSelected(sectionTitle: String, option: String) -> Bool {
        (selections[sectionTitle] ?? []).contains(option)
    }

    func saveSettings(onSuccess: @escaping () -> Void) {
        guard !isSaving else { return }
        isSaving = true
        alertMessage = nil

        let dto = CounselSettingRequestDTO(
            atmosphere: mapAtmosphere(last(of: "대화 분위기")),
            supportStyle: mapSupportStyle(last(of: "도움방식")),
            roleCounselor: mapRole(last(of: "역할")),
            answerFormat: mapAnswerFormat(last(of: "답변형식")),
            tone: mapTone(last(of: "말투"))
        )

        service.saveSetting(dto)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isSaving = false

                if case let .failure(err) = completion {
                    // COUNSELOR409는 "이미 존재"이므로 앱에서는 성공으로 간주하고 진행
                    if self.isAlreadyConfigured(err) {
                        onSuccess()
                        return
                    }
                    self.alertMessage = self.describe(err)
                }
            } receiveValue: { _ in
                onSuccess()
            }
            .store(in: &cancellables)
    }

    func clearAlert() { alertMessage = nil }

    private func last(of sectionTitle: String) -> String? {
        selections[sectionTitle]?.last
    }

    private func isAlreadyConfigured(_ error: APIError) -> Bool {
        guard case let .serverError(code, _) = error else { return false }
        return code == "COUNSELOR409"
    }

    private func mapAtmosphere(_ text: String?) -> String? {
        switch text {
        case "친근함": return "EMOTIONAL"
        case "따뜻함": return "WARM"
        case "차분함": return "CALM"
        default: return nil
        }
    }

    private func mapSupportStyle(_ text: String?) -> String? {
        switch text {
        case "공감 & 경청형": return "EMPATHIC"
        case "해결 & 조언형": return "SOLUTION"
        case "팩트형": return "FACT"
        default: return nil
        }
    }

    private func mapRole(_ text: String?) -> String? {
        switch text {
        case "상담사": return "COUNSELOR"
        case "친구": return "FRIEND"
        case "멘탈 코치": return "MENTAL_COACH"
        default: return nil
        }
    }

    private func mapAnswerFormat(_ text: String?) -> String? {
        switch text {
        case "짧고 간결": return "SHORT_FORMAT"
        case "길고 자세히": return "LONG_FORMAT"
        case "상황에 맞게": return "SITUATIONAL"
        default: return nil
        }
    }

    private func mapTone(_ text: String?) -> String? {
        switch text {
        case "존댓말": return "FORMAL"
        case "반말": return "UNFORMAL"
        default: return nil
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
}
