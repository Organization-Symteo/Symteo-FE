//
//  NicknameEditViewModel.swift
//  Symteo
//
//  Created by 김지우 on 2/20/26.
//

import Foundation
import Combine

@MainActor
final class NicknameEditViewModel: ObservableObject {

    enum Mode {
        case signup   // 초기 등록(가입 완료 처리)
        case edit     // MY심터 닉네임 수정
    }

    // Input
    @Published var nickname: String = ""

    // UI State
    @Published var isChecking: Bool = false
    @Published var isSaving: Bool = false
    @Published var isDuplicated: Bool = false
    @Published var validationMessage: String? = nil
    @Published var apiErrorMessage: String? = nil

    private let mode: Mode
    private let service: UserServicing
    private var cancellables = Set<AnyCancellable>()

    
    private let regex = "^[A-Za-z0-9가-힣]{3,10}$"

    init(
        mode: Mode,
        service: UserServicing = UserService()
    ) {
        self.mode = mode
        self.service = service
        bind()
    }

    private func bind() {
        $nickname
            .removeDuplicates()
            .debounce(for: .milliseconds(400), scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                self?.apiErrorMessage = nil
                self?.validateAndCheck(text)
            }
            .store(in: &cancellables)
    }

    private func validateAndCheck(_ text: String) {
        guard !text.isEmpty else {
            validationMessage = nil
            isDuplicated = false
            return
        }

        guard isFormatValid(text) else {
            validationMessage = "닉네임은 한글/영문/숫자 3~10자리여야 합니다."
            isDuplicated = false
            return
        }

        validationMessage = nil
        checkDuplicate(text)
    }

    private func isFormatValid(_ text: String) -> Bool {
        return text.range(of: regex, options: .regularExpression) != nil
    }

    private func checkDuplicate(_ nickname: String) {
        isChecking = true
        service.checkNickname(nickname)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isChecking = false
                if case let .failure(error) = completion {
                    self?.apiErrorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] result in
                self?.isDuplicated = result.isDuplicated
            }
            .store(in: &cancellables)
    }

    var canSave: Bool {
        guard !nickname.isEmpty else { return false }
        guard validationMessage == nil else { return false }
        guard !isDuplicated else { return false }
        return true
    }

    /// 성공 시 호출자에게 닉네임/토큰 갱신을 위임
    func save(
        onSignupSuccess: @escaping (_ response: SignupNicknameResponseDTO) -> Void,
        onEditSuccess: @escaping (_ result: UpdateNicknameResultDTO) -> Void
    ) {
        guard canSave else { return }

        isSaving = true
        apiErrorMessage = nil

        switch mode {
        case .signup:
            service.signupNickname(nickname)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    self?.isSaving = false
                    if case let .failure(error) = completion {
                        self?.apiErrorMessage = error.localizedDescription
                    }
                } receiveValue: { response in
                    onSignupSuccess(response)
                }
                .store(in: &cancellables)

        case .edit:
            service.updateNickname(nickname)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    self?.isSaving = false
                    if case let .failure(error) = completion {
                        self?.apiErrorMessage = error.localizedDescription
                    }
                } receiveValue: { result in
                    onEditSuccess(result)
                }
                .store(in: &cancellables)
        }
    }
}
