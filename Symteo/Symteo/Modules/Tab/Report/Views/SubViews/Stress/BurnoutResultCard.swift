//
//  StressAnalysisCard.swift
//  Symteo
//
//  Created by 박병선 on 1/22/26.
//
import SwiftUI

// StressReportView에서 번아웃 결과를 보여주는 하위뷰입니다.
struct BurnoutResultCard: View {

    @ObservedObject var viewModel: StressReportViewModel

    var body: some View {
        VStack(spacing: 14) {

            // 번아웃 분석 섹션
            BurnoutAnalysisSection(viewModel: viewModel)
                .reportCardStyle()

            // ai 분석 섹션
            BurnoutAIInsightSection(insights: viewModel.aiInsights)
                .reportCardStyle()
        }
        .padding()
    }
}

//MARK: -SubViews(private)
/// 번아웃 분석 섹션
private struct BurnoutAnalysisSection: View {

    @ObservedObject var viewModel: StressReportViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text("번아웃의 3가지 신호 (상세분석)")
                .font(.PretendardSemiBold(size: 16))
                .foregroundStyle(.gray900)

            HStack(spacing: 12) {

                // 정서적 소진
                BurnoutSignalItem(
                    title: "정서적 소진",
                    level: viewModel.emotionalExhaustion.title,
                    description: viewModel.emotionalExhaustion.description,
                    ratio: viewModel.emotionalExhaustion.ratio,
                    color: viewModel.emotionalExhaustion.progressColor
                )

                // 성취감 저하
                BurnoutSignalItem(
                    title: "성취감 저하",
                    level: viewModel.personalAccomplishment.title,
                    description: viewModel.personalAccomplishment.description,
                    ratio: viewModel.personalAccomplishment.ratio,
                    color: viewModel.personalAccomplishment.progressColor
                )

                // 비인격화
                BurnoutSignalItem(
                    title: "비인격화",
                    level: viewModel.depersonalization.title,
                    description: viewModel.depersonalization.description,
                    ratio: viewModel.depersonalization.ratio,
                    color: viewModel.depersonalization.progressColor
                )
            }
        }
    }
}

/// 순수 UI 컴포넌트
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

// MARK: -AI 섹션
private struct BurnoutAIInsightSection: View {
    
    let insights: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            // 타이틀(고정)
            Text("심터 AI의 통찰: 왜 지금 힘들까?")
                .font(.PretendardSemiBold(size: 16))
                .foregroundStyle(.gray900)
            
            /* api 연결 전 더미데이터
             // 인사이트 1
             AIInsightRow(
             title: "PSS의 과부하와 번아웃의 정서적 소진이 너무 높습니다.", description:  "일상적이고 반복적인 업무에서 에너지가 고갈된 ‘만성적 소진’의 신호입니다.")
             
             // 인사이트 2
             AIInsightRow(
             title: "지난 달보다 통제력 점수가 급격히 하락했습니다.", description:  "최근 갑작스러운 환경 변화가 있었는지 되돌아 보세요.")
             */
            
            ForEach(insights.prefix(3), id: \.self) { insight in
                AIInsightRow(text: insight)
                
                
            }
            .padding(24)
        }
    }
    
    /// 순수 UI 컴포넌트
    private struct AIInsightRow: View {
        let text: String
        
        var body: some View {
            HStack(alignment: .top, spacing: 12) { // 아이콘을 텍스트 첫 줄 상단에 맞춤
                
                /// 아이콘: 상단 고정
                Image("AI_image")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                
                /// 텍스트 영역
                Text(text)
                    .font(.PretendardRegular(size: 14))
                    .foregroundStyle(.gray700)
                
                Spacer()
                
            }
            .padding(.vertical, 4) // 행 사이의 간격
        }
    }
}
