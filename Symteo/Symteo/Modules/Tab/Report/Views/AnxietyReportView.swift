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
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var sessionManager: SessionManager

    
    // MARK: -이니셜라이저
    init(reportId: Int,container: DIContainer) {
        _viewModel = StateObject(
            wrappedValue: AnxietyReportViewModel(
                reportId: reportId,
                container: container
            )
        )
    }
    

    // MARK: -Body
    var body: some View {
        ZStack(alignment: .top) {

            Color.white
                .ignoresSafeArea()

            VStack(spacing: 0) {

            
                ZStack(alignment: .top) {

                    Color.maingreen
                        .clipShape(
                            RoundedCorner(
                                radius: 16,
                                corners: [.bottomLeft, .bottomRight]
                            )
                        )
                        .ignoresSafeArea(edges: .top)

                    ReportNavigationBar(userName: sessionManager.userName)

                    /// 종합 결과 섹션
                    OverallResultSection(result: viewModel.overallResult)
                        .padding(.horizontal, 20)
                        .offset(y: 70)
                }
                .frame(height: 110)   // 겹침 + 헤더 고정

                // 스크롤 영역
                ScrollView {
                    VStack(spacing: 20) {
                            TabView(selection: $currentPage) {
                                /// 우울 결과 카드
                                DepressionResultCard(data: viewModel.depressionResult)
                                    .tag(0)
                                
                                /// 불안 결과 카드
                                AnxietyResultCard(data: viewModel.anxietyResult)
                                    .tag(1)
                            }
                            .tabViewStyle(.page(indexDisplayMode: .never))
                            .frame(height: UIScreen.main.bounds.height * 0.75)

                        
                        /// 커스텀 인디케이터
                        customIndicator
                        
                        /// AI 설명 섹션
                        AIPrecisionSection(items: viewModel.aiInsightCards)
                        
                        /// 긴급 대응섹션 (PHQ-9 9번 응답 시에만)
                        if viewModel.isEmergency {
                            EmergencyResponseSection()
                        }

                        /// 하단 바
                        ReportBottomBar( onConsultTap: {
                            container.navigationRouter.push(.service) /// 상담사 버튼
                        },
                        onOtherTestTap: {
                            container.navigationRouter.pop() ///dismiss()
                        })
                    }
                    .padding(.top, 60) // 겹친 카드 아래 여백
                }
            }
            // 로딩
            if viewModel.isLoading {
                ReportLoadingView()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if viewModel.summary == nil {
                   viewModel.getAnxietyDepressionReport()
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


