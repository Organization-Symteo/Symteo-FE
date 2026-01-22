//
//  AnxietyReportView.swift
//  Symteo
//
//  Created by 박병선 on 1/18/26.
//  우울/불안 리포트 화면입니다. 
import SwiftUI

struct AnxietyReportView: View {
    @Environment(\.dismiss) var dismiss
    @State private var currentPage = 0 // 페이지 스와이프(현재페이지 추적)
    @StateObject private var viewModel: AnxietyReportViewModel
    
    init(phqScore: Int, gadScore: Int) {
        _viewModel = StateObject(
            wrappedValue: AnxietyReportViewModel(
                phqScore: phqScore,
                gadScore: gadScore
            )
        )
    }
    
    
    var body: some View {
        VStack(spacing: 0) {
            
            // 헤더 영역
            ZStack(alignment: .top) {
                
                Color.maingreen
                    .clipShape(RoundedCorner(radius: 16,corners: [.bottomLeft, .bottomRight]))
                    .ignoresSafeArea(edges: .top)
                
                // 상단 네비게이션바
                ReportNavigationBar()
                    //.padding(.top, 8)
                
            }
            .frame(height: 100) //  헤더 높이 고정
            
            Image(viewModel.overallLevel.resultImage)
                .resizable()
                .frame(width: 380, height: 90)
                .offset(y: -40)
                .padding(.bottom, -60) // 아래 여백 제거
            
        }
        
        
        
        ScrollView {
            VStack(spacing: 20) {
                
                TabView(selection: $currentPage) {
                    DepressionResultCard(data: .preview)
                        .tag(0)
                    // data: .preview
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
            .padding(.top, 20)
        }
        .background(Color.white)
    }
    
    
    
    private var customIndicator: some View {
        HStack(spacing: 8) {
            Spacer()
            
            ForEach(0..<2, id: \.self) { index in
                if currentPage == index {
                    Image("indicator_selected")
                        .resizable()
                        .frame(width: 18, height: 8)
                } else {
                    Image("indicator_normal")
                        .resizable()
                        .frame(width: 8, height: 8)
                }
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
