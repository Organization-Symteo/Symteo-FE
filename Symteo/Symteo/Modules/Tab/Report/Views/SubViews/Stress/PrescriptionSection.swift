//
//  PrescriptionSection.swift
//  Symteo
//
//  Created by 박병선 on 1/22/26.
//
import SwiftUI

struct PrescriptionSection: View {

    var body: some View {
        VStack(spacing: 24) {

            // 타이틀
            Text("따오기님을 위한 심터의 처방") // TODO: 실제 유저이름
                .font(.PretendardSemiBold(size: 20))
                .foregroundStyle(.gray900)
                .multilineTextAlignment(.center)

            // 중앙 이미지
            Image("stress_madicine")
                .resizable()
                .scaledToFit()
                .frame(width: 115, height: 115)

            // 설명 문구
            Text("""
            번아웃은 열심히 살았다는 증거입니다.
            이제는 자신에게 친절할 시간이에요.
            """)
            .font(.PretendardMedium(size: 14))
            .foregroundStyle(.gray700)
            .multilineTextAlignment(.center)
            .lineSpacing(4)

            // CTA 버튼
            Button(action: {
                // TODO: 상담화면 연결
                print("AI 상담사와 함께")
            }) {
                HStack(spacing: 16) {

                    Image("report_plan")   // 캘린더 아이콘
                        .resizable()
                        .frame(width: 32, height: 32)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("AI 상담사와 함께")
                            .font(.PretendardSemiBold(size: 16))

                        Text("지금 더 이야기 하러가기")
                            .font(.PretendardMedium(size: 14))
                    }

                    Spacer() 
                }
                .foregroundStyle(Color(hex: "#0E9F6E"))
                .padding(.horizontal, 24)
                .padding(.vertical, 10)
                .background(
                    LinearGradient(
                        colors: [
                            Color(hex: "#B7EBD8"),
                            Color(hex: "#E6F4C9")
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(16)
            }
        }
        .padding(24)
        .padding(.horizontal, 20)
        //.cardStyle()
    }
}

#Preview {
    PrescriptionSection()
}
