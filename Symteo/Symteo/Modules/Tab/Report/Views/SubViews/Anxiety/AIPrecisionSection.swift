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

    let items: [AIInsightCard]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text("AI 정밀 분석")
                .font(.PretendardSemiBold(size: 16))
                .foregroundStyle(.gray900)

            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ],
                spacing: 12
            ) {
                ForEach(items, id: \.id) { item in
                    PrecisionItemView(
                        title: item.title,
                        subtitle: item.subtitle
                    )
                }
            }
        }
        .padding(.horizontal, 20)
    }
}
    
/// 순수 UI 컴포넌트
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

