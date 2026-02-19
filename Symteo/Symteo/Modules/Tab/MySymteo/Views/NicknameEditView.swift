//
//  NicknameEditView.swift
//  Symteo
//
//  Created by 박정환 on 1/31/26.
//

import SwiftUI

struct NicknameEditView: View {

    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var loginRouter: LoginRouter
    @EnvironmentObject var container: DIContainer
    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel: NicknameEditViewModel

    // MY심터: edit, 초기등록: signup 으로 넘겨서 재사용
    init(mode: NicknameEditViewModel.Mode = .edit) {
        _viewModel = StateObject(wrappedValue: NicknameEditViewModel(mode: mode))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            ZStack {
                HStack {
                    Button { dismiss() } label: { Image("icn_arrow_left") }
                    Spacer()
                }

                Text("닉네임 수정")
                    .font(.PretendardRegular(size: 14))
                    .foregroundStyle(.gray900)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)

            Text("심터에서 사용할\n닉네임을 알려주세요!")
                .font(.PretendardMedium(size: 22))
                .lineSpacing(8)
                .foregroundStyle(.gray900)
                .padding(.top, 21)
                .padding(.horizontal, 16)

            TextField("한글, 영문, 숫자를 포함하여 3-10자까지 가능합니다.", text: $viewModel.nickname)
                .font(.PretendardRegular(size: 14))
                .padding(16)
                .background(Color.gray30)
                .cornerRadius(12)
                .padding(.top, 32)
                .padding(.horizontal, 16)

            // Validation / Duplicate / Checking
            VStack(alignment: .leading, spacing: 6) {
                if let msg = viewModel.validationMessage {
                    HStack(spacing: 6) {
                        Image(systemName: "xmark.circle.fill").foregroundStyle(.red)
                        Text(msg)
                            .font(.PretendardRegular(size: 14))
                            .foregroundStyle(.red)
                    }
                } else if !viewModel.nickname.isEmpty {
                    if viewModel.isChecking {
                        HStack(spacing: 6) {
                            ProgressView()
                            Text("중복 검사 중...")
                                .font(.PretendardRegular(size: 14))
                                .foregroundStyle(.gray500)
                        }
                    } else if viewModel.isDuplicated {
                        HStack(spacing: 6) {
                            Image(systemName: "xmark.circle.fill").foregroundStyle(.red)
                            Text("이미 사용 중인 닉네임입니다.")
                                .font(.PretendardRegular(size: 14))
                                .foregroundStyle(.red)
                        }
                    } else {
                        HStack(spacing: 6) {
                            Image(systemName: "checkmark.circle.fill").foregroundStyle(.blue)
                            Text("사용 가능한 닉네임이에요")
                                .font(.PretendardRegular(size: 14))
                                .foregroundStyle(.blue)
                        }
                    }
                }

                if let apiErr = viewModel.apiErrorMessage {
                    Text(apiErr)
                        .font(.PretendardRegular(size: 12))
                        .foregroundStyle(.red)
                }
            }
            .padding(.top, 8)
            .padding(.horizontal, 16)

            Spacer()

            MainBottomButton(
                text: viewModel.isSaving ? "저장 중..." : "저장",
                isDisabled: !viewModel.canSave || viewModel.isSaving,
                action: {
                    viewModel.save(
                        onSignupSuccess: { response in

                            sessionManager.applyNicknameSaved(response.nickname)

                            // 초기 진입 흐름 분기(기존 로직 유지)
                            if sessionManager.flow == .needsCounselor {
                                container.navigationRouter.push(.counselsetting)
                            } else {
                                dismiss()
                            }
                        },
                        onEditSuccess: { result in
                            sessionManager.applyNicknameSaved(result.nickname)
                            dismiss()
                        }
                    )
                }
            )
            .padding(.bottom, 11)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            // 기존 닉네임 세팅
            if let existingNickname = sessionManager.nickname {
                viewModel.nickname = existingNickname
            }
        }
    }
}


#Preview {
    NicknameEditView()
        .environmentObject(SessionManager(keychain: .shared))
        .environmentObject(LoginRouter())
}
