//
//  StressReportView.swift
//  Symteo
//
//  Created by 박병선 on 1/18/26.
//
import SwiftUI

struct StressReportView: View {
    @State private var currentPage = 0
    @StateObject var viewModel: StressReportViewModel
    @EnvironmentObject var container: DIContainer
    @Environment(\.dismiss) var dismiss

    // MARK: -initializer
    init(reportId: Int, container: DIContainer) {
          _viewModel = StateObject(
              wrappedValue: StressReportViewModel(
                  reportId: reportId,
                  container: container
              )
          )
      }
 
    var body: some View {
        ZStack(alignment: .top) {

            //  전체 배경
            Color.white
                .ignoresSafeArea()

            VStack(spacing: 0) {

                //  헤더 + 배터리 겹침 영역
                ZStack(alignment: .top) {

                    // 헤더 배경
                    Color.maingreen
                        .clipShape(
                            RoundedCorner(
                                radius: 16,
                                corners: [.bottomLeft, .bottomRight]
                            )
                        )
                        .ignoresSafeArea(edges: .top)

                    // 네비게이션 바
                    ReportNavigationBar(userName: "따오기")

                    //  배터리 섹션
                    BatterySection(percent: viewModel.batteryPercent)
                        .padding(.horizontal, 20)
                        .offset(y: 70)   //  ReportNavigationBar와 겹침
                }
                .frame(height: 110) // 헤더 + 겹침 공간

                //  스크롤 영역
                ScrollView {
                    VStack(spacing: 20) {

                        TabView(selection: $currentPage) {
                            StressResultCard(viewModel: viewModel)
                                .tag(0)

                            BurnoutResultCard(viewModel: viewModel)
                                .tag(1)
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .frame(height: UIScreen.main.bounds.height * 0.75)

                        customIndicator
                        
                        PrescriptionSection(onChatTap: {
                                                    container.selectedTab = .chat
                                                })
        
                        MainBottomButton(
                            text: "다른 검사하러 가기",
                            isDisabled: false,
                            action: {
                                dismiss()
                            }
                        )
                    }
                    .padding(.top, 60) // 배터리 카드 아래 여백
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.getStressReport()
        }
    }

    
    
    // MARK: - 커스텀 인디케이터 
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

