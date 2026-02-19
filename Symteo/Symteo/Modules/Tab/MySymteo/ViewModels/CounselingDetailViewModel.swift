//
//  CounselingDetailViewModel.swift
//  Symteo
//
//  Created by 김지우 on 2/20/26.
//

import Foundation
import Combine

@MainActor
final class CounselingDetailViewModel: ObservableObject {

    @Published var record: CounselingRecord? = nil
    @Published var isLoading: Bool = false
    @Published var isDeleting: Bool = false
    @Published var errorMessage: String? = nil

    private let service: CounselServicing
    private var cancellables = Set<AnyCancellable>()

    init(service: CounselServicing = CounselService()) {
        self.service = service
    }

    func load(chatRoomId: Int, fallbackDate: String, fallbackTitle: String) {
        isLoading = true
        errorMessage = nil

        service.fetchCounselDetail(chatRoomId: chatRoomId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                if case let .failure(err) = completion {
                    self.errorMessage = err.localizedDescription
                }
            } receiveValue: { [weak self] dto in
                guard let self else { return }
                // date는 목록에서 가져온 걸 유지
                var mapped = CounselingRecord.fromDetailDTO(dto, dateTime: fallbackDate)
                // 혹시 서버 chatSummary가 비면 fallback
                if mapped.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    mapped = CounselingRecord(
                        counselId: mapped.counselId,
                        date: mapped.date,
                        title: fallbackTitle,
                        userContent: mapped.userContent,
                        aiResponse: mapped.aiResponse
                    )
                }
                self.record = mapped
            }
            .store(in: &cancellables)
    }

    func delete(chatRoomId: Int, onSuccess: @escaping () -> Void) {
        isDeleting = true
        errorMessage = nil

        service.deleteCounsel(chatRoomId: chatRoomId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isDeleting = false
                if case let .failure(err) = completion {
                    self.errorMessage = err.localizedDescription
                }
            } receiveValue: { _ in
                onSuccess()
            }
            .store(in: &cancellables)
    }
}
