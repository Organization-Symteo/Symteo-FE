//
//  AttachmentReportView.swift
//  Symteo
//
//  Created by 박병선 on 1/18/26.
//  성향 리포트 화면입니다.
import SwiftUI

struct AttachmentReportView: View {
    @Environment(\.dismiss) var dismiss
    @State private var currentPage = 0
    @StateObject var viewModel: AttachmentReportViewModel
    @EnvironmentObject var container: DIContainer
  
    // MARK: -initializer
    init(reportId: Int, container: DIContainer) {
          _viewModel = StateObject(
              wrappedValue: AttachmentReportViewModel(
                  reportId: reportId,
                  container: container
              )
          )
      }
    var body: some View {
        ZStack(alignment: .top) {
            
            //전체 배경
            Color.white.ignoresSafeArea()
            
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
                    ReportNavigationBar(userName: viewModel.userName)
                    
                    // 애착유형섹션
                    AttachmentTypeSection(type: .anxious)
                        .padding(.horizontal, 20)
                        .offset(y: 70)   //  ReportNavigationBar와 겹침
                }
                .frame(height: 110) // 헤더 + 겹침 공간
                
                //  스크롤 영역
                ScrollView {
                    VStack(spacing: 20) {
                        
                        TabView(selection: $currentPage) {
                            AttachmentResultCard(viewModel: viewModel)
                                .tag(0)
                            
                            AttachmentAnalysisCard()
                                .tag(1)
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .frame(height: UIScreen.main.bounds.height * 0.75)
                        
                        customIndicator
                        /// 하단 바
                        ReportBottomBar( onConsultTap: {
                            container.navigationRouter.push(.service) /// 상담사 버튼
                        },
                        onOtherTestTap: {
                            container.navigationRouter.pop() ///dismiss()
                        })
                    }
                    
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Indicator
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

