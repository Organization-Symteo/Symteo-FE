//
//  StressAnalysisCard.swift
//  Symteo
//
//  Created by 박병선 on 1/22/26.
//
import SwiftUI


struct BurnoutResultCard: View {
 
    var body: some View {
        VStack(spacing: 14) {

          BurnoutAnalysisSection()
                .cardStyle()
            BurnoutAIInsightSection()
                .cardStyle()
        }
        .padding()

     
    }
}

//MARK: -SubViews(private)
private struct BurnoutAnalysisSection: View {

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text("번아웃의 3가지 신호 (상세분석)")
                .font(.PretendardSemiBold(size: 16))
                .foregroundStyle(.gray900)

            HStack(spacing: 12) {
                BurnoutSignalItem(
                    title: "정서적 소진",
                    level: "매우 심각",
                    description: "마음의 에너지가 바닥났어요.",
                    ratio: 0.85,
                    color: Color(hex: "#F4574F")
                )

                BurnoutSignalItem(
                    title: "성취감 저하",
                    level: "심각",
                    description: "내가 잘하고 있는지 모르겠어요.",
                    ratio: 0.65,
                    color: Color(hex: "#FFAC79")
                )

                BurnoutSignalItem(
                    title: "비인격화",
                    level: "매우 낮음",
                    description: "사람들과 거리를 두고 싶어요.",
                    ratio: 0.25,
                    color: Color(hex: "#63B19B")
                )
            }
        }
    }
}

private struct BurnoutSignalItem: View {

    let title: String
    let level: String
    let description: String
    let ratio: Double
    let color: Color

    var body: some View {
        VStack(spacing: 8) {

            Text(title)
                .font(.PretendardSemiBold(size: 14))
                .foregroundStyle(.gray900)

            Text("(\(level))")
                .font(.PretendardRegular(size: 12))
                .foregroundStyle(color)
            Text(description)
                .font(.PretendardRegular(size: 12))
                .foregroundStyle(.gray900)
                .multilineTextAlignment(.center)

            RingProgressView(
                ratio: ratio,
                color: color
            )
            .frame(width: 70, height: 70)
            .padding(.top,10)

      
        }
        .padding(12)
        .frame(maxWidth: .infinity)
       
    }
}

private struct RingProgressView: View {

    let ratio: Double
    let color: Color

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.15), lineWidth: 10)

            Circle()
                .trim(from: 0, to: ratio)
                .stroke(
                    color,
                    style: StrokeStyle(lineWidth: 10, lineCap: .square)
                )
                .rotationEffect(.degrees(-90))
        }
    }
}

private struct BurnoutAIInsightSection: View {

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            // 타이틀
            Text("심터 AI의 통찰: 왜 지금 힘들까?")
                .font(.PretendardSemiBold(size: 16))
                .foregroundStyle(.gray900)

            // 인사이트 1
            AIInsightRow(
                title: "PSS의 과부하와 번아웃의 정서적 소진이 너무 높습니다.", description:  "일상적이고 반복적인 업무에서 에너지가 고갈된 ‘만성적 소진’의 신호입니다."
    
            )
            
            // 인사이트 2
            AIInsightRow(
                title: "지난 달보다 통제력 점수가 급격히 하락했습니다.", description:  "최근 갑작스러운 환경 변화가 있었는지 되돌아 보세요."
    
            )

       
        }
        .padding(24)
    }
}

private struct AIInsightRow: View {
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) { // 아이콘을 텍스트 첫 줄 상단에 맞춤

            // 1. 아이콘: 상단 고정
            Image("AI_image")
                .resizable()
                .scaledToFit()
                .frame(width: 36, height: 36)
            
            // 2. 텍스트 영역: 왼쪽 정렬 강제
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.PretendardSemiBold(size: 15)) // 피그마 대비 굵기/크기 조정
                    .foregroundStyle(.gray900)
             
                
                Text(description)
                    .font(.PretendardRegular(size: 14)) // 가독성을 위해 살짝 키움
                    .foregroundStyle(.gray700) // 설명은 약간 더 연한 회색 권장
                   
            }
            
            Spacer()
           
        }
        .padding(.vertical, 4) // 행 사이의 간격
    }
}
#Preview {
    BurnoutResultCard()
        .padding()
        .background(Color.gray.opacity(0.05))
}
