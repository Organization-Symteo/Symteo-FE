//
//  CounselingRecordViewModel.swift
//  Symteo
//
//  Created by 김지우 on 2/20/26.
//

import Foundation
import Combine

@MainActor
final class CounselingRecordListViewModel: ObservableObject {

    @Published var records: [CounselingRecord] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let service: CounselServicing
    private var cancellables = Set<AnyCancellable>()

    init(service: CounselServicing = CounselService()) {
        self.service = service
    }

    func load() {
        isLoading = true
        errorMessage = nil

        service.fetchCounselList()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                if case let .failure(err) = completion {
                    self.errorMessage = err.localizedDescription
                }
            } receiveValue: { [weak self] list in
                guard let self else { return }
                // 최신 10개만
                self.records = list.prefix(10).map { CounselingRecord.fromListDTO($0) }
            }
            .store(in: &cancellables)
    }
}
