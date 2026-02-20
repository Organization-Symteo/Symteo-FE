//
//  CounselSettingViewModel.swift
//  Symteo
//
//  Created by 김지우 on 2/5/26.
//

import Foundation
import SwiftUI
import Combine

enum CounselSettingUsage {
    case onboarding
    case chatEdit
    case myEdit

    var isOnboarding: Bool {
        if case .onboarding = self { return true }
        return false
    }
}

@MainActor
final class CounselSettingViewModel: ObservableObject {

    @Published var sections: [CounselSection] = [
        CounselSection(title: "대화 분위기", options: ["친근함", "따뜻함", "차분함"], isMultiSelect: false),
        CounselSection(title: "도움방식", options: ["공감 & 경청형", "해결 & 조언형", "팩트형"], isMultiSelect: false),
        CounselSection(title: "역할", options: ["상담사", "친구", "멘탈 코치"], isMultiSelect: false),
        CounselSection(title: "답변형식", options: ["짧고 간결", "길고 자세히", "상황에 맞게"], isMultiSelect: false),
        CounselSection(title: "말투", options: ["존댓말", "반말"], isMultiSelect: false)
    ]

    @Published var selections: [String: Set<String>] = [
        "대화 분위기": ["친근함"],
        "도움방식": ["공감 & 경청형"],
        "역할": ["상담사"],
        "답변형식": ["짧고 간결"],
        "말투": ["존댓말"]
    ]

    @Published var isSaving: Bool = false
    @Published var isLoading: Bool = false
    @Published var alertMessage: String? = nil

    private let service: CounselServicing
    private var cancellables = Set<AnyCancellable>()

    init(service: CounselServicing = CounselService()) {
        self.service = service
    }

    func toggleOption(sectionTitle: String, option: String, isMultiSelect: Bool) {
        var currentSet = selections[sectionTitle] ?? []

        if isMultiSelect {
            if currentSet.contains(option) { currentSet.remove(option) }
            else { currentSet.insert(option) }
        } else {
            currentSet.removeAll()
            currentSet.insert(option)
        }

        selections[sectionTitle] = currentSet
    }

    func isSelected(sectionTitle: String, option: String) -> Bool {
        selections[sectionTitle]?.contains(option) ?? false
    }

    func loadExistingSettingIfNeeded(usage: CounselSettingUsage) {
        if usage.isOnboarding { return }
        guard !isLoading else { return }

        isLoading = true
        alertMessage = nil

        service.fetchSetting()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false

                if case let .failure(err) = completion {
                    if case let .serverError(code, _) = err, code == "COUNSELOR404" {
                        return
                    }
                    self.alertMessage = self.describe(err)
                }
            } receiveValue: { [weak self] dto in
                self?.applyFetchedSettingToUI(dto)
            }
            .store(in: &cancellables)
    }

    func save(usage: CounselSettingUsage, onSuccess: @escaping () -> Void) {
        guard !isSaving else { return }
        isSaving = true
        alertMessage = nil

        let request = makeRequestDTO()

        switch usage {
        case .onboarding:
            saveByUpsert(request: request, onSuccess: onSuccess)

        case .chatEdit, .myEdit:
            saveByUpdateThenFallback(request: request, onSuccess: onSuccess)
        }
    }

    private func saveByUpsert(request: CounselSettingRequestDTO, onSuccess: @escaping () -> Void) {
        service.upsertSetting(request)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isSaving = false

                if case let .failure(err) = completion {
                    self.alertMessage = self.describe(err)
                }
            } receiveValue: { _ in
                onSuccess()
            }
            .store(in: &cancellables)
    }

    private func saveByUpdateThenFallback(request: CounselSettingRequestDTO, onSuccess: @escaping () -> Void) {
        service.updateSetting(request)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }

                if case let .failure(err) = completion {
                    if self.isMissingUpdateEndpoint(err) {
                        self.fallbackUpsertAfterUpdateMissing(request: request, onSuccess: onSuccess)
                        return
                    }

                    self.isSaving = false
                    self.alertMessage = self.describe(err)
                    return
                }
            } receiveValue: { [weak self] _ in
                guard let self else { return }
                self.isSaving = false
                onSuccess()
            }
            .store(in: &cancellables)
    }

    private func fallbackUpsertAfterUpdateMissing(request: CounselSettingRequestDTO, onSuccess: @escaping () -> Void) {
        service.upsertSetting(request)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isSaving = false

                if case let .failure(err) = completion {
                    if case let .serverError(code, message) = err, code == "COUNSELOR409" {
                        self.alertMessage = "서버가 기존 설정 수정 API를 지원하지 않아 저장할 수 없습니다. 서버에 PATCH /api/v1/users/counselor-settings(또는 PUT upsert) 지원이 필요합니다."
                        return
                    }
                    self.alertMessage = self.describe(err)
                }
            } receiveValue: { _ in
                onSuccess()
            }
            .store(in: &cancellables)
    }

    private func isMissingUpdateEndpoint(_ error: APIError) -> Bool {
        switch error {
        case let .serverError(code, message):
            if code == "404" || code == "405" { return true }
            if message.lowercased().contains("not found") { return true }
            if message.lowercased().contains("method not allowed") { return true }
            return false
        default:
            return false
        }
    }

    private func makeRequestDTO() -> CounselSettingRequestDTO {
        CounselSettingRequestDTO(
            atmosphere: mapAtmosphereToServer(pickOne(in: "대화 분위기")) ?? "EMOTIONAL",
            supportStyle: mapSupportStyleToServer(pickOne(in: "도움방식")) ?? "EMPATHIC",
            roleCounselor: mapRoleToServer(pickOne(in: "역할")) ?? "COUNSELOR",
            answerFormat: mapAnswerFormatToServer(pickOne(in: "답변형식")) ?? "SHORT_FORMAT",
            tone: mapToneToServer(pickOne(in: "말투")) ?? "FORMAL"
        )
    }

    private func pickOne(in sectionTitle: String) -> String? {
        guard let section = sections.first(where: { $0.title == sectionTitle }) else { return nil }
        let selected = selections[sectionTitle] ?? []
        return section.options.first(where: { selected.contains($0) })
    }

    private func mapAtmosphereToServer(_ ui: String?) -> String? {
        switch ui {
        case "친근함": return "EMOTIONAL"
        case "따뜻함": return "WARM"
        case "차분함": return "CALM"
        default: return nil
        }
    }

    private func mapSupportStyleToServer(_ ui: String?) -> String? {
        switch ui {
        case "공감 & 경청형": return "EMPATHIC"
        case "해결 & 조언형": return "SOLUTION"
        case "팩트형": return "FACT"
        default: return nil
        }
    }

    private func mapRoleToServer(_ ui: String?) -> String? {
        switch ui {
        case "상담사": return "COUNSELOR"
        case "친구": return "FRIEND"
        case "멘탈 코치": return "MENTAL_COACH"
        default: return nil
        }
    }

    private func mapAnswerFormatToServer(_ ui: String?) -> String? {
        switch ui {
        case "상황에 맞게": return "SITUATIONAL"
        case "짧고 간결": return "SHORT_FORMAT"
        case "길고 자세히": return "LONG_FORMAT"
        default: return nil
        }
    }

    private func mapToneToServer(_ ui: String?) -> String? {
        switch ui {
        case "존댓말": return "FORMAL"
        case "반말": return "UNFORMAL"
        default: return nil
        }
    }

    private func applyFetchedSettingToUI(_ dto: CounselSettingResultDTO) {
        selections["대화 분위기"] = [mapAtmosphereToUI(dto.atmosphere ?? "EMOTIONAL")]
        selections["도움방식"] = [mapSupportStyleToUI(dto.supportStyle ?? "EMPATHIC")]
        selections["역할"] = [mapRoleToUI(dto.roleCounselor ?? "COUNSELOR")]
        selections["답변형식"] = [mapAnswerFormatToUI(dto.answerFormat ?? "SHORT_FORMAT")]
        selections["말투"] = [mapToneToUI(dto.tone ?? "FORMAL")]
    }

    private func mapAtmosphereToUI(_ server: String) -> String {
        switch server {
        case "EMOTIONAL": return "친근함"
        case "WARM": return "따뜻함"
        case "CALM": return "차분함"
        default: return "친근함"
        }
    }

    private func mapSupportStyleToUI(_ server: String) -> String {
        switch server {
        case "EMPATHIC", "EMPATHETIC": return "공감 & 경청형"
        case "SOLUTION": return "해결 & 조언형"
        case "FACT": return "팩트형"
        default: return "공감 & 경청형"
        }
    }

    private func mapRoleToUI(_ server: String) -> String {
        switch server {
        case "COUNSELOR": return "상담사"
        case "FRIEND": return "친구"
        case "MENTAL_COACH": return "멘탈 코치"
        default: return "상담사"
        }
    }

    private func mapAnswerFormatToUI(_ server: String) -> String {
        switch server {
        case "SITUATIONAL": return "상황에 맞게"
        case "SHORT_FORMAT": return "짧고 간결"
        case "LONG_FORMAT": return "길고 자세히"
        case "CONVERSATIONAL": return "상황에 맞게"
        default: return "짧고 간결"
        }
    }

    private func mapToneToUI(_ server: String) -> String {
        switch server {
        case "FORMAL": return "존댓말"
        case "UNFORMAL": return "반말"
        default: return "존댓말"
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
