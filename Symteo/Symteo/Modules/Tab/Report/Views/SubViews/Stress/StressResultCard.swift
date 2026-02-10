//
//  StressResultCard.swift
//  Symteo
//
//  Created by 박병선 on 1/22/26.
//
import SwiftUI

// 스트레스 리포트 화면에서 스트레스 결과를 보여주는 하위뷰입니다.
struct StressResultCard: View {

    let userName: String
    @ObservedObject var viewModel: StressReportViewModel

    var body: some View {
        VStack(spacing: 20) {

            // 스트레스 게이지
            StressGaugeSection(
                score: viewModel.pssScore,
                level: viewModel.stressLevel,
                ratio: viewModel.stressRatio,
                fillColor: viewModel.stressColor
            )
            .reportCardStyle()

            //  설명 섹션
            StressDescriptionSection(
                userName: userName,
                level: viewModel.stressLevel,
                description: viewModel.stressDescriptionText
            )
            .reportCardStyle()

            // 통제력 / 과부하
            StressBalanceSection(
                situationalResult: viewModel.situationalControlResult,
                dailyOverloadResult: viewModel.dailyOverloadResult
            )
            .reportCardStyle()
        }
        .padding()
    }
}

// MARK: -SubViews
private struct StressGaugeSection: View {

    let score: Int
    let level: StressLevel
    let ratio: CGFloat
    let fillColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text("나의 스트레스 온도 (PSS)")
                .font(.PretendardSemiBold(size: 16))
                .foregroundStyle(.gray900)

            Image(level.imageName)
                   .resizable()
                   .aspectRatio(305 / 72, contentMode: .fit)
                   .frame(maxWidth: .infinity)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(level.title)
                        .font(.PretendardSemiBold(size: 16))
                        .foregroundStyle(level.color)

                    Text("(\(level.rangeText))")
                        .font(.PretendardRegular(size: 12))
                        .foregroundStyle(.gray700)
                }

                Text("\"\(level.description)\"")
                    .font(.PretendardMedium(size: 14))
                    .foregroundStyle(.gray900)
            }
        }
    }
}


private struct StressDescriptionSection: View {

    let userName: String
    let level: StressLevel
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            HStack{
                Text("\(userName)님의 스트레스 온도는")
                    .font(.PretendardSemiBold(size: 15))
                    .foregroundStyle(.gray900)
                
                Text("'\(level.title)'")
                    .font(.PretendardSemiBold(size: 15))
                    .foregroundStyle(level.color)
                
                Text("입니다.")
                    .font(.PretendardSemiBold(size: 15))
                    .foregroundStyle(.gray900)
                
            }
            
            Text(description)
                .font(.PretendardRegular(size: 13))
                .foregroundStyle(.gray700)
                .lineSpacing(4)
        }
    }
}


// MARK: - 통제감 vs 과부하 영역
private struct StressBalanceSection: View {
    
    let situationalResult: StressBalanceResult
    let dailyOverloadResult: StressBalanceResult

    var body: some View {
            VStack(alignment: .leading, spacing: 14) {

                header

                StressBalanceRow(
                    title: "상황 통제감",
                    result: situationalResult
                )

                StressBalanceRow(
                    title: "일상의 과부하",
                    result: dailyOverloadResult
                )
            }
            .padding(16)

        }
    

        private var header: some View {
            VStack(alignment: .leading, spacing: 4) {
                Text("통제력 vs 과부하")
                    .font(.PretendardSemiBold(size: 16))
                    .foregroundStyle(.gray900)

                Text("*통제감은 높을수록, 과부하는 낮을수록 긍정신호")
                    .font(.PretendardRegular(size: 12))
                    .foregroundStyle(.gray600)
                    
            }
        }
}

private struct StressBalanceRow: View {
    let title: String
    let result: StressBalanceResult

    var body: some View {
        HStack(alignment: .top, spacing: 20) {

            // 제목 + 상태
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.PretendardSemiBold(size: 14))
                    .foregroundStyle(Color.gray900)

                Text("(\(result.levelText))")
                    .font(.PretendardSemiBold(size: 13))
                    .foregroundStyle(result.barColor)
            }
            .frame(width: 80, alignment: .leading) // 2. 프로그레스바 시작점 정렬을 위한 고정폭
            

            // 오른쪽: 프로그레스바 + 설명
            VStack(alignment: .leading, spacing: 10) {
                ProgressBarView(
                    ratio: result.ratio,
                    barColor: result.barColor
                )
                .frame(maxWidth: .infinity) // 가로 길이를 꽉 채워 정렬
                .frame(height: 12)

                // 3. 상세설명 한 줄 고정 로직
                Text(result.description)
                    .font(.PretendardRegular(size: 13))
                    .foregroundStyle(Color.gray700)
                    .lineLimit(1)                // 한 줄로 제한
                    .fixedSize(horizontal: false, vertical: true) // 텍스트가 수직으로 늘어나는 것을 방지
            
                        .allowsTightening(true)      // 자간을 살짝 좁혀서 최대한 다 보여주려 노력함
                        .layoutPriority(1)           // 다른 요소보다 텍스트 레이아웃 우선순위를 높임
            }
        }
        .padding(.vertical, 8)
    }
}


private struct ProgressBarView: View {

    let ratio: Double
    let barColor: Color

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {

                Capsule()
                    .fill(Color.gray.opacity(0.15))

                Capsule()
                    .fill(barColor)
                    .frame(width: geo.size.width * ratio)
            }
        }
        .frame(height: 10)
    }
}
