//
//  AttachmentAnalysisCard.swift
//  Symteo
//
//  Created by 박병선 on 1/22/26.
//
import SwiftUI

// AttachmentView에서 애착 분석결과를 나타낸 하위뷰입니다.
 struct AttachmentAnalysisCard: View {
     var body: some View {
             VStack(spacing: 16) {
                 // 1. 나의 스트레스 포인트 섹션
                 StressPointSection()
                     .reportCardStyle() // 미리 만드신 카드 스타일 적용
                 
                 // 2. 나의 강점 섹션 (가로 병렬 카드)
                 MyStrengthsSection()
                     .reportCardStyle()
                 // 이 섹션은 내부에서 개별 카드에 .cardStyle()을 적용합니다.
                 
                 // 3. 행동 추천 섹션
                 ActionRecommendationSection()
                     .reportCardStyle()
             }
             .padding()
         }
 }
 

//MARK: -SubViews(private)
private struct StressPointSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("애착 분석: 나의 ‘성향’ 이해하기")
                .font(.PretendardSemiBold(size: 16))
                .foregroundStyle(.gray900)
            
            VStack(spacing: 12) {
                StressPointRow(text: "상대방의 연락이 늦어지거나 표정이 조금만 변해도, 혹시 내가 잘못해서 거절당할까 봐 걱정되지 않나요?")
                StressPointRow(text: "상대방의 연락이 늦어지거나 표정이 조금만 변해도, 혹시 내가 잘못해서 거절당할까 봐 걱정되지 않나요?")
            }
        }
    }
}

private struct StressPointRow: View {
    let text: String
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image("emoticon_stress")
                    .resizable()
                    .frame(width: 20, height: 20)
                
                Text("나의 스트레스 포인트:")
                    .font(.PretendardSemiBold(size: 14))
                    .foregroundStyle(.gray900)
            }
            Text(text)
                .font(.PretendardRegular(size: 12))
                .foregroundStyle(.gray900)
                //.lineSpacing(4)
        }
        .padding()
        .background(Color(hex: "FFF5F5")) // 연한 핑크 배경
        .cornerRadius(12)
    }
}

struct MyStrengthsSection: View {
    var body: some View {
        HStack(spacing: 12) {
            StrengthCard(text: "섬세한 감수성으로 상대의 감정과 필요를 깊이 있게 읽어내는 따뜻한 능력을 가졌어요")
               
            StrengthCard(text: "섬세한 감수성으로 상대의 감정과 필요를 깊이 있게 읽어내는 따뜻한 능력을 가졌어요")
                
        }
    }
}

private struct StrengthCard: View {
    let text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Image("emoticon_happy")
                    .resizable()
                    .frame(width: 20, height: 20)
                
                Text("나의 강점:")
                    .font(.PretendardBold(size: 14))
            }
            Text(text)
                .font(.PretendardRegular(size: 13))
                .lineSpacing(2)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(hex: "#E9F6FC"))
        .cornerRadius(12)
                                               
    }
}

struct ActionRecommendationSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 타이틀 부분
            HStack(spacing: 8) {
                Image("icon_good")
                    .resizable()
                    .frame(width: 18, height: 18)
                
                Text("나의 애착 유형에 맞는 행동 추천")
                    .font(.PretendardSemiBold(size: 16))
                    .foregroundStyle(.gray900)
            }
            .padding(.bottom, 16)
            
            Divider()
                .padding(.horizontal, -16) // 카드의 패딩을 무시하고 선을 긋기 위함
            
            // 내용 부분
            VStack(alignment: .leading, spacing: 10) {
                Text("거절과 버림에 대해서 두려워할 필요없어요.")
                Text("타인의 반응에 둔감해지는 연습이 필요합니다.")
            }
            .font(.PretendardRegular(size: 14))
            .foregroundStyle(.gray900)
            .padding(.top, 16)
        }
    }
}

#Preview{
    AttachmentAnalysisCard()
}
