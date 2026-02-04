//
//  AIInsightSection.swift
//  Symteo
//
//  Created by 박병선 on 1/20/26.
//
// AI 정밀 분석 화면
// TODO: 각자 title 및 subtitle 연결
import SwiftUI

struct AIPrecisionSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    PrecisionItemView(
                        title: "수면 장애 심각",
                        subtitle: "(PHQ-9 #3)"
                    )
                    
                    PrecisionItemView(
                        title: "지속적인 걱정",
                        subtitle: "(GAD-7 #2)"
                    )
                    
                    PrecisionItemView(
                        title: "신체적 긴장",
                        subtitle: "(GAD-7 #6)"
                    )
                }
                .padding(.horizontal)
            }
        }
    }
    
    struct PrecisionItemView: View {
        let title: String
        let subtitle: String
        
        var body: some View {
            VStack(spacing: 6) {
                HStack{
                    Image("sparkle")
                        .resizable()
                        .frame(width:14, height: 14)
                    
                    Text("AI 정밀 분석")
                        .font(.PretendardMedium(size: 12))
                        .foregroundStyle(.gray600)
                }
                
                
                Text(title)
                    .font(.PretendardMedium(size: 14))
                    .foregroundStyle(.gray900)
                
                Text(subtitle)
                    .font(.PretendardRegular(size: 14))
                    .foregroundStyle(.gray600)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .cornerRadius(12)
        }
    }
}

#Preview{
    AIPrecisionSection()
}
