//
//  Untitled.swift
//  Symteo
//
//  Created by 박병선 on 1/18/26.
//
//  메인리포트 화면입니다.
import SwiftUI

struct MainReportView: View {
    let userName: String
    @EnvironmentObject var container: DIContainer
    @StateObject private var viewModel: MainReportViewModel
    
    // MARK: -initializer
    init(
           userName: String,
           container: DIContainer
       ) {
           self.userName = userName
           _viewModel = StateObject(
               wrappedValue: MainReportViewModel(container: container)
           )
       }
    
    // MARK: -Body
    var body: some View {
        ZStack {
            // 메인 콘텐츠 레이어
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        headerSection
                        reportListSection
                        bannerSection
                        promotionSection
                    }
                    .padding()
                }
                .navigationBarHidden(true)
            }
            
            // 팝업레이어
            if viewModel.isShowingNoReportPopUp {
                // 배경 어둡게 처리
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        viewModel.isShowingNoReportPopUp = false
                    }
                
        
                PopUpView(
                    title: "저장된 리포트가 없습니다.",
                    message: "진단하러 가시겠습니까?",
                    confirmTitle: "확인",
                    cancelTitle: "취소",
                    onConfirm: {
                        viewModel.isShowingNoReportPopUp = false
                        // TODO: 진단하기 이동 로직
                    },
                    onCancel: {
                        viewModel.isShowingNoReportPopUp = false
                    }
                )
                .transition(.scale.combined(with: .opacity))
            }
        } // ZStack 끝
        .animation(.spring(), value: viewModel.isShowingNoReportPopUp)
    } 
    
    // MARK: - 1. 헤더
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("\(viewModel.userName)")
                    .font(.PretendardSemiBold(size: 18))
                    .foregroundStyle(Color.gray900)
                Text("님을 위한")
                    .font(.PretendardRegular(size: 18))
                    .foregroundStyle(Color(hex: "000000"))
            }
            Text("마음 리포트")
                .font(.PretendardSemiBold(size: 22))
                .foregroundStyle(Color.gray900)
        }
        .padding(.top, 10)
        .padding(.leading)
    }
    
    // MARK: - 2. 리포트 리스트 섹션
    private var reportListSection: some View {
        VStack(spacing: 12) {

            
            ReportListRow(
                icon: "anxiety_icon",
                title: "우울·불안 리포트",
                subtitle: "내 마음 속에 숨은 비구름을 확인해봐요",
                hasReport: viewModel.hasAnxietyReport,

                destination: {
                    Group {
                           if case let .available(reportId) = viewModel.stressReportStatus {
                               StressReportView(
                                   viewModel: StressReportViewModel(
                                       reportId: reportId,
                                       container: container
                                   )
                               )
                           }
                       }
                },

                onEmptyTap: {
                    viewModel.isShowingNoReportPopUp = true
                }
            )

            ReportListRow(
                icon: "stress_icon",
                title: "스트레스 리포트",
                subtitle: "어깨에 짊어진 무거운 짐을 내려놓을 시간",
                hasReport: viewModel.hasStressReport,
                destination: {
                    Group {
                        if case let .available(reportId) = viewModel.stressReportStatus {
                            StressReportView(
                                viewModel: StressReportViewModel(
                                    reportId: reportId,
                                    container: container
                                )
                            )
                        }
                    }
                },
                onEmptyTap: {
                    viewModel.isShowingNoReportPopUp = true
                }
            )

            ReportListRow(
                icon: "attachment_icon",
                title: "애착 리포트",
                subtitle: "나의 애착유형과 성향을 알아가는 시간",
                hasReport: viewModel.hasAttachmentReport,

                destination: {
                    Group {
                        if case let .available(reportId) = viewModel.attachmentReportStatus {
                            AttachmentReportView(
                                viewModel: AttachmentReportViewModel(
                                    reportId: reportId,
                                    container: container
                                )
                            )
                        }
                    }
                },

                onEmptyTap: {
                    viewModel.isShowingNoReportPopUp = true
                }
            )
        }
        .padding(.vertical, 8)
    }

    
    // MARK: - 3. 중간 배너 (상담 안내)
    private var bannerSection: some View {
        Button(action: {
            print("상담 화면으로 이동")
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                
                HStack(spacing: 12) {
                    Image("report_message")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 43, height: 43)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("지금 내 상태, 더 정확히 알고 싶어요")
                            .font(.PretendardSemiBold(size: 16))
                            .foregroundStyle(Color.gray900)
                        
                        Text("내 리포트 기반으로 바로 상담까지")
                            .font(.PretendardMedium(size: 12))
                            .foregroundStyle(Color.gray600)
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.03), radius: 14, x: 0,y: 6)
            .frame(height: 88)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - 4. 하단 측정 홍보
    private var promotionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            TabView(selection: $viewModel.currentPromoPage) {
                ForEach(0..<viewModel.promotionList.count, id: \.self) { index in
                    let item = viewModel.promotionList[index]
                    
                    NavigationLink(destination: promoDestinationView(for: item.type)) {
                        Image(item.imageName)
                            .resizable()
                            .scaledToFit()
                    }
                    .buttonStyle(PlainButtonStyle())
                    .tag(index)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.03), radius: 14, x: 0,y: 6)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 140)
            
            // 커스텀 인디케이터
            HStack(spacing: 6) {
                Spacer()
                ForEach(0..<viewModel.promotionList.count, id: \.self) { index in
                    Image(viewModel.currentPromoPage == index ? "indicator_selected" : "indicator_normal")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 6)
                }
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    private func promoDestinationView(for type: PromotionType) -> some View {
        switch type {
        case .anxiety:
            Text("우울 진단 테스트 화면")
        case .stress:
            Text("스트레스 진단 테스트 화면")
        case .attachment:
            Text("성향 진단 테스트 화면")
        }
    }
}

