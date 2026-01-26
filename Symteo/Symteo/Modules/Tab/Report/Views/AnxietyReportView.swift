//
//  AnxietyReportView.swift
//  Symteo
//
//  Created by 박병선 on 1/18/26.
//  우울/불안 리포트 화면입니다. 
import SwiftUI

struct AnxietyReportView: View {
    @State private var currentPage = 0
    @StateObject private var viewModel: AnxietyReportViewModel

    init(phqScore: Int, gadScore: Int) {
        _viewModel = StateObject(
            wrappedValue: AnxietyReportViewModel(
                phqScore: phqScore,
                gadScore: gadScore
            )
        )
    }

    let overallResult = OverallResult(
        phqScore: 9,
        gadScore: 9,
        averageScore: 9,
        status: .attention
    )

    var body: some View {
        ZStack(alignment: .top) {

            Color.white
                .ignoresSafeArea()

            VStack(spacing: 0) {

                // 🔹 헤더 + 종합결과 겹침 영역
                ZStack(alignment: .top) {

                    Color.maingreen
                        .clipShape(
                            RoundedCorner(
                                radius: 16,
                                corners: [.bottomLeft, .bottomRight]
                            )
                        )
                        .ignoresSafeArea(edges: .top)

                    ReportNavigationBar()

                    OverallResultSection(result: overallResult)
                        .padding(.horizontal, 20)
                        .offset(y: 70)
                }
                .frame(height: 110)   // 겹침 + 헤더 고정

                // 스크롤 영역
                ScrollView {
                    VStack(spacing: 20) {

                        TabView(selection: $currentPage) {
                            DepressionResultCard(data: .preview)
                                .tag(0)

                            AnxietyResultCard(data: .preview)
                                .tag(1)
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .frame(height: UIScreen.main.bounds.height * 0.75)

                        customIndicator
                        AIPrecisionSection()
                        EmergencyResponseSection()
                        ReportBottomBar()
                    }
                    .padding(.top, 60) // 겹친 카드 아래 여백
                }
            }
        }
    }

    private var customIndicator: some View {
        HStack(spacing: 8) {
            Spacer()
            ForEach(0..<2, id: \.self) { index in
                Image(
                    currentPage == index
                    ? "indicator_selected"
                    : "indicator_normal"
                )
                .resizable()
                .frame(
                    width: currentPage == index ? 18 : 8,
                    height: 8
                )
            }
            Spacer()
        }
        .padding(.top, 8)
    }
}


#Preview {
    AnxietyReportView(
            phqScore: 14,
            gadScore: 11
        )
}
