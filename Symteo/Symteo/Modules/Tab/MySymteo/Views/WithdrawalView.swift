//
//  WithdrawalView.swift
//  Symteo
//
//  Created by 박정환 on 1/31/26.
//

import SwiftUI

struct WithdrawalView: View {

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var sessionManager: SessionManager

    @State private var isAgreed: Bool = false
    @StateObject private var accountViewModel = AccountViewModel()

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

                Text("회원 탈퇴")
                    .font(.PretendardRegular(size: 14))
                    .foregroundStyle(.gray900)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Text("회원 탈퇴 전 주의 사항")
                        .font(.PretendardMedium(size: 16))
                        .foregroundStyle(.gray900)
                        .padding(.top, 20)
                        .padding(.bottom, 4)

                    Text("탈퇴 시 모든 서비스 이용내역이 삭제되며 복구가 불가능합니다.\n또한 같은 계정 정보로 재가입이 7일 동안 불가능합니다.")
                        .font(.PretendardMedium(size: 12))
                        .foregroundStyle(.gray500)

                    VStack(alignment: .leading, spacing: 8) {
                        bulletText("계정 정보 및 사용자 설정 정보", "   닉네임 정보, 사용자가 설정했던 모든 정보들 삭제")
                        bulletText("상담기록", "   AI 상담사와의 상담기록 내용 및 보관 데이터 삭제")
                        bulletText("미션기록", "   미션 정보 및 미션 보관 기록 데이터 삭제")
                        bulletText("그 외 모든 구매 기록 및 정보 삭제", "")
                    }
                    .padding(.top, 16)

                    Button {
                        isAgreed.toggle()
                    } label: {
                        HStack(spacing: 8) {
                            Image(isAgreed ? "icn_check" : "icn_noncheck")

                            Text("(필수) 위 주의 사항을 모두 확인했으며, 탈퇴에 동의합니다.")
                                .font(.PretendardMedium(size: 14))
                                .foregroundStyle(.gray900)
                        }
                    }
                    .padding(.top, 24)

                    Spacer(minLength: 120)
                }
                .padding(.horizontal, 16)
            }

            HStack(spacing: 12) {

                Button {
                    accountViewModel.withdraw()
                } label: {
                    Text("탈퇴하기")
                        .font(.PretendardSemiBold(size: 16))
                        .foregroundStyle(.gray700)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.gray100)
                        .cornerRadius(12)
                }
                .disabled(!isAgreed || accountViewModel.isLoading)
                .opacity(isAgreed ? 1.0 : 0.4)

                Button {
                    dismiss()
                } label: {
                    Text("취소")
                        .font(.PretendardSemiBold(size: 16))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.maingreen)
                        .cornerRadius(12)
                }
                .disabled(accountViewModel.isLoading)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            accountViewModel.bind(sessionManager: sessionManager)
        }
    }

    private func bulletText(_ title: String, _ desc: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("• \(title)")
                .font(.PretendardMedium(size: 14))
                .foregroundStyle(.gray900)

            if !desc.isEmpty {
                Text(desc)
                    .font(.PretendardMedium(size: 12))
                    .foregroundStyle(.gray500)
            }
        }
    }
}

#Preview {
    WithdrawalView()
}
