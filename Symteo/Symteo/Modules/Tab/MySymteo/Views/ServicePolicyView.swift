//
//  ServicePolicyView.swift
//  Symteo
//
//  Created by 박정환 on 2/1/26.
//


import SwiftUI

struct ServicePolicyView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                
                ZStack {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image("icn_arrow_left")
                        }
                        
                        Spacer()
                    }
                    
                    Text("서비스 약관 및 정책")
                        .font(.PretendardRegular(size: 14))
                        .foregroundStyle(.gray900)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.white)
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading) {
                        
                        PolicyTitle(text: "심터 서비스 약관 및 정책")
                        
                        PolicyContent("""
• ‘심터’ 이용자의 개인정보를 중요하게 생각하며, 관련 법령을 준수합니다.
• 본 개인정보 처리방침은 이용자의 개인정보 수집·이용·보관·파기에 대한 내용을 포함합니다.
• 회사는 개인정보 보호와 권익 보장을 위해 최선을 다합니다.
• 공고일자: 2025년 12월 13일
• 시행일자: 2025년 12월 13일
""", bottomPadding: 24)
                        
                        PolicyTitle(text: "개인정보의 수집 및 이용 목적")
                        
                        PolicyContent(
                            "회사는 다음의 목적 범위 내에서만 개인정보를 처리하며, 목적 달성 후에는 관련 법령 및 내부 정책에 따라 안전하게 파기합니다.",
                            bottomPadding: 10
                        )
                        
                        PolicySubTitle(text: "1. 서비스 제공 및 운영")
                        
                        PolicyContent("""
• 알람 설정, 일정 관리, 맞춤형 콘텐츠 제공
• 서비스 오류 대응 및 민원 처리
""")
                        
                        PolicySubTitle(text: "2. 회원 및 계정 관리")
                        
                        PolicyContent("""
• 간편 로그인 기반 회원 식별
• 부정 이용 방지
""")
                        
                        PolicySubTitle(text: "3. 서비스 개선 및 분석")
                        
                        PolicyContent("""
• UX/UI 개선
• 통계 분석 활용
""")
                        
                        PolicySubTitle(text: "4. 글글글")
                        
                        PolicyContent("• 글글글")
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

struct PolicyTitle: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.PretendardMedium(size: 16))
                    .foregroundStyle(.gray900)
            .padding(.bottom, 12)
    }
}

struct PolicySubTitle: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.PretendardMedium(size: 14))
            .foregroundStyle(.gray900)
            .padding(.bottom, 4)
    }
}

struct PolicyContent: View {
    let text: String
    let bottomPadding: CGFloat

    init(_ text: String, bottomPadding: CGFloat = 8) {
        self.text = text
        self.bottomPadding = bottomPadding
    }

    var body: some View {
        Text(text)
            .font(.PretendardRegular(size: 12))
            .foregroundStyle(.gray900)
            .lineSpacing(4)
            .padding(.bottom, bottomPadding)
    }
}

#Preview {
    ServicePolicyView()
}
