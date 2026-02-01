//
//  SettingView.swift
//  Symteo
//
//  Created by 박정환 on 1/30/26.
//

import SwiftUI

struct SettingView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var alarmOn = false
    @State private var cheerOn = false
    @State private var analysisOn = false
    @State private var monthlyOn = false
    @State private var showLogoutPopup = false
    @State private var showInquiryPopup = false

var body: some View {
    ZStack {
        ScrollView(showsIndicators: false) {

            VStack(alignment: .leading, spacing: 0) {

                // 알림 설정
                sectionTitle("알림 설정")

                SettingRowToggle(
                    title: "알림 설정",
                    isOn: $alarmOn
                )

                SettingRowToggle(
                    title: "응원 메시지",
                    isOn: $cheerOn
                )

                SettingRowToggle(
                    title: "검사지 분석 완료",
                    isOn: $analysisOn
                )

                SettingRowToggle(
                    title: "월간 진단 알림",
                    isOn: $monthlyOn
                )

                Divider().padding(.vertical, 16)

                // 사용자 설정
                sectionTitle("사용자 설정")

                settingArrowRow("잠금 설정")
                settingArrowRow("상담사 설정")

                Divider().padding(.vertical, 16)

                // 내 계정
                sectionTitle("내 계정")

                NavigationLink {
                    NicknameEditView()
                } label: {
                    settingArrowRow("닉네임 수정")
                }
                Button {
                    withAnimation {
                        showLogoutPopup = true
                    }
                } label: {
                    settingArrowRow("로그아웃")
                }
                NavigationLink {
                    WithdrawalView()
                } label: {
                    settingArrowRow("회원 탈퇴하기")
                }

                Divider().padding(.vertical, 16)

                // 기타
                sectionTitle("기타")

                NavigationLink {
                    ServicePolicyView()
                } label: {
                    settingArrowRow("서비스 약관 및 정책")
                }
                
                NavigationLink {
                    PrivacyPolicyView()
                } label: {
                    settingArrowRow("개인정보 처리방침")
                }
                
                Button {
                    withAnimation {
                        showInquiryPopup = true
                    }
                } label: {
                    settingArrowRow("문의하기")
                }

                HStack {
                    Text("앱 정보")
                        .font(.PretendardMedium(size: 14))
                        .foregroundColor(.gray900)
                    Spacer()
                    Text("0.0.1")
                        .font(.PretendardRegular(size: 14))
                        .foregroundColor(.gray700)                }
                .padding(.vertical, 72)
            }
            .padding(.horizontal, 16)
        }

        // Logout Popup
        if showLogoutPopup {
            PopUpView(
                title: "로그아웃을 하면 메세지 알림을 받을 수 없습니다.\n정말 로그아웃 하시겠습니까?",
                message: nil,
                confirmTitle: "로그아웃",
                cancelTitle: "취소",
                onConfirm: {
                    withAnimation {
                        showLogoutPopup = false
                    }
                    logout()
                },
                onCancel: {
                    withAnimation {
                        showLogoutPopup = false
                    }
                }
            )
        }
        // Inquiry Popup
        if showInquiryPopup {
            PopUpView(
                title: "심터 문의",
                message: "cs@symteo.com로 이메일을 보내주세요.",
                confirmTitle: "확인",
                cancelTitle: nil,
                onConfirm: {
                    withAnimation {
                        showInquiryPopup = false
                    }
                },
                onCancel: {
                    withAnimation {
                        showInquiryPopup = false
                    }
                }
            )
        }
    }
    .navigationTitle("")
    .navigationBarTitleDisplayMode(.inline)
    .navigationBarBackButtonHidden(true)
    .toolbar {
        
        ToolbarItem(placement: .principal) {
            Text("환경 설정")
                .font(.PretendardRegular(size: 14))
                .foregroundColor(.gray900)
        }
        
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                dismiss()
            } label: {
                Image("icn_arrow_left")
            }
        }
    }
    }
}

    private func logout() {
        // TODO: 로그아웃 API 연동
        print("로그아웃 처리")
    }

    // MARK: - Helper

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.PretendardSemiBold(size: 16))
            .foregroundColor(.gray900)
            .padding(.vertical, 16)
    }

    private func settingArrowRow(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.PretendardMedium(size: 14))
                .foregroundColor(.gray900)

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.gray700)
        }
        .padding(.vertical, 16)
    }


struct SettingRowToggle: View {

    let title: String
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            Text(title)
                .font(.PretendardMedium(size: 14))
                .foregroundColor(.gray900)

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(.maingreen)
        }
        .padding(.vertical, 12)
    }
}

#Preview {
    SettingView()
}
