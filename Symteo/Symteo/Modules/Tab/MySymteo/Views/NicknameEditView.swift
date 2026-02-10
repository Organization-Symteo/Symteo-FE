//
//  NicknameEditView.swift
//  Symteo
//
//  Created by 박정환 on 1/31/26.
//

import SwiftUI

struct NicknameEditView: View {

    @Environment(\.dismiss) private var dismiss
    @State private var nickname: String = ""
    @State private var showError: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            ZStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image("icn_arrow_left")
                    }

                    Spacer()
                }

                Text("닉네임 수정")
                    .font(.PretendardRegular(size: 14))
                    .foregroundColor(.gray900)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)

            // Title
            Text("심터에서 사용할\n닉네임을 알려주세요!")
                .font(.PretendardMedium(size: 22))
                .lineSpacing(8)
                .foregroundColor(.gray900)
                .padding(.top, 21)
                .padding(.horizontal, 16)

            // TextField
            TextField("한글, 영문, 숫자를 포함하여 3-10자까지 가능합니다.", text: $nickname)
                .font(.PretendardRegular(size: 14))
                .padding(16)
                .background(Color.gray30)
                .cornerRadius(12)
                .padding(.top, 32)
                .padding(.horizontal, 16)
                .onChange(of: nickname) { _ in
                    validate()
                }

            // Validation Message
            if showError {
                HStack(spacing: 6) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)

                    Text("2-10자 이내로 입력해주세요")
                        .font(.PretendardRegular(size: 14))
                        .foregroundColor(.red)
                }
                .padding(.top, 8)
                .padding(.horizontal, 16)

            } else if isValid && !nickname.isEmpty {

                HStack(spacing: 6) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)

                    Text("사용 가능한 닉네임이에요")
                        .font(.PretendardRegular(size: 14))
                        .foregroundColor(.blue)
                }
                .padding(.top, 8)
                .padding(.horizontal, 16)
            }

            Spacer()

            // Save Button
            MainBottomButton(
                text: "저장",
                isDisabled: !isValid,
                action: {
                    saveNickname()
                }
            )
            .padding(.bottom, 11)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }

    // MARK: - Validation

    private var isValid: Bool {
        nickname.count >= 2 && nickname.count <= 10
    }

    private func validate() {
        showError = !isValid && !nickname.isEmpty
    }

    private func saveNickname() {
        guard isValid else {
            showError = true
            return
        }

        // TODO: 서버 / 로컬 저장 연동
        dismiss()
    }
}

#Preview {
    NicknameEditView()
}
