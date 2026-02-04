//
//  EmergencyResponseSection.swift
//  Symteo
//
//  Created by 박병선 on 1/19/26.
//
//  PHQ-9번 문항 응답 시 나타나는 하위 섹션입니다. AnxietyReportView에서 확인할 수 있습니다. 
import SwiftUI

struct EmergencyResponseSection: View {
    var body: some View {
            ZStack {
                // 바깥 테두리
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color(hex: "BE4E48"), lineWidth: 2)
                    .frame(width: 344, height: 200)

                // 안쪽 콘텐츠
                VStack(spacing: 10) {

                    // 상단 보조 설명
                    Text("(PHQ-9 9번 문항 응답)")
                        .font(.PretendardMedium(size: 12))
                        .foregroundStyle(.gray400)

                    // 메인 경고 텍스트
                    Text("긴급 도움 필요")
                        .font(.PretendardSemiBold(size: 20))
                        .foregroundStyle(Color(hex: "BE4E48"))

                    // 설명 문구
                    VStack(spacing: 8) {
                        Text("지금 힘든 마음이 드시나요?")
                            .font(.PretendardSemiBold(size: 16))
                            .foregroundStyle(Color(hex: "555555"))

                        Text("24시간 전문가와 상담할 수 있습니다.")
                            .font(.PretendardSemiBold(size: 16))
                            .foregroundStyle(Color(hex: "555555"))
                    }

                    //  하단 CTA 버튼
                    Button(action: {
                        // TODO: Action 연결
                    }) {
                        Text("24시간 상담 전화 연결(109)")
                            .font(.PretendardSemiBold(size: 16))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "BE4E48"))
                            .cornerRadius(16)
                    }
                }
                .padding(24)
            }
            .padding(.horizontal, 16)
        }
    
}

#Preview {
    EmergencyResponseSection()
}
