//
//  Untitled.swift
//  Symteo
//
//  Created by 박병선 on 1/18/26.
//
//  메인리포트 화면입니다.
import SwiftUI

struct MainReportView: View {
    @StateObject private var viewModel = MainReportViewModel()
    
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
                // 배경 어둡게 처리 (Dim)
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
    } // body 끝
    
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
        VStack(spacing: -25) {
            ForEach(viewModel.reportList) { item in
                // 클릭 시 데이터가 없으면 팝업을 띄우는 로직
                Button(action: {
                    // 실제로는 데이터 존재 여부를 체크해야 함
                    viewModel.isShowingNoReportPopUp = false
                }) {
                    Image(item.fullImageName)
                        .resizable()
                        .scaledToFit()
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.03), radius: 14, x: 0,y: 6)
    }
    
    // MARK: - 목적지 분기 처리 (Helper Function)
    /*
    @ViewBuilder
    private func destinationView(for type: ReportType) -> some View {
        switch type {
        case .anxiety:
            AnxietyReportView()
        case .stress:
            StressReportView()
        case .attachment:
            AttachmentReportView()
        }
    }
     */
    
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

// MARK: - Preview
#Preview {
    MainReportView()
}
