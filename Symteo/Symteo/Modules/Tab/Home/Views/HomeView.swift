//
//  HomeView.swift
//  Symteo
//
//  Created by 박병선 on 1/7/26.
//
import SwiftUI
import Combine


// 홈 화면 코드입니다. 
struct HomeView: View {
    // MARK: - Properties
    @EnvironmentObject var sessionManager: SessionManager
    @State private var selectedDiagnosis: RecommendationType? // 하단의 추천 검사 분기를 위한 프로퍼티
    @State private var currentPage = 0 // 페이지 스와이프(현재페이지 추적)
    @StateObject private var viewModel : HomeViewModel
    
    @EnvironmentObject var container: DIContainer
    
    /// 추천 검사 아이템(우울/불안, 스트레스, 성향 검사)
    private let recommendationItems: [RecommendationItem] = [
        .init(imageName: "anxiety_test", type: .anxiety),
        .init(imageName: "stress_test", type: .stress),
        .init(imageName: "attachment_test", type: .attachment)
    ]
    
    
    
    // MARK: - Init
    
    /// DIContainer을 주입받아 초기화
    init(
        container: DIContainer
    ) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(container: container))
    }
    
    // MARK: -Body
    
    var body: some View {
        VStack(spacing: 0) {
            /// 상단 커스텀 네비게이션
            navigationBar
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 10) {
                    welcomeHeader
                    emotionWeatherSection
                    todayMissionCard
                    recommendationSection
                    aiCounselingBanner
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 30)
            }
            
            .background(Color(hex: "F8F9FA")) /// 전체 배경색 (필요시 수정)
            .task {
                viewModel.loadHome()
            }
        }
    }
}
    
    // MARK: - Subviews
    extension HomeView {
        
        ///  네비게이션 바
        private var navigationBar: some View {
            HStack {
                Image("home_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 23)
                
                Text("심터")
                    .font(.PretendardSemiBold(size: 18))
                    .foregroundStyle(.maingreen)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        
        ///  오늘의 한줄
        private var welcomeHeader: some View {
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("오늘의 한 줄")
                        .font(.PretendardMedium(size: 12))
                        .foregroundStyle(.green400)
                    
                    if !viewModel.todayLine.isEmpty {
                        Text(viewModel.todayLine)
                            .font(.PretendardSemiBold(size: 16))
                            .foregroundStyle(.gray700)
                    }
                }
                
                Spacer()
                
            }
        }
        
        /// 감정 날씨 섹션
        private var emotionWeatherSection: some View {
            VStack(alignment: .leading, spacing: 16) {
                Text("오늘 나의 감정 날씨를 선택해봐요")
                    .font(.PretendardMedium(size: 14))
                    .foregroundStyle(.gray900)
                
                HStack(spacing: 16) {
                    ForEach(EmotionWeather.allCases, id: \.id) { weather in
                        WeatherButton(
                            weather: weather,
                            isSelected: viewModel.selectedWeather == weather,
                            isAnySelected: viewModel.selectedWeather != nil,
                            action: {
                                withAnimation(.spring()) {
                                    viewModel.updateTodayWeather(weather)
                                }
                            }
                        )
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(20)
        }
        
        /// 오늘의 미션 카드
        private var todayMissionCard: some View {
            HStack {
                Image("home_note")
                    .resizable()
                    .frame(width: 25, height: 25)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("하루 한 조각씩 채우는 마음")
                        .font(.PretendardRegular(size: 12))
                        .foregroundStyle(.gray600)
                    
                    Text("오늘의 미션")
                        .font(.PretendardSemiBold(size: 18))
                        .foregroundStyle(.gray900)
                }
                
                Spacer()
                
                Button {
                    container.navigationRouter.push(.mission) /// 미션화면으로 이동
                }label: {
                    Text("하러가기")
                        .font(.PretendardMedium(size: 14))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(.maingreen)
                        .cornerRadius(16)
                }
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(16)
        }
        
        /// 추천 섹션
        private var recommendationSection: some View {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 0) {
                    Text("\(sessionManager.userName)")
                        .font(.PretendardSemiBold(size: 14))
                        .foregroundStyle(.gray900)
                    
                    Text("님을 위한 추천")
                        .font(.PretendardRegular(size: 14))
                        .foregroundStyle(.gray900)
                    
                    Spacer()
                }
                .padding(.horizontal, 4)
                .padding(.leading, 15)
                .padding(.top)
                
                TabView(selection: $currentPage) {
                    ForEach(Array(recommendationItems.enumerated()), id: \.offset) { index, item in
                        Button {
                            switch item.type {
                            case .anxiety:
                                container.navigationRouter.push(.depressionTest)
                            case .stress:
                                container.navigationRouter.push(.stressTest)
                            case .attachment:
                                container.navigationRouter.push(.typeTest)
                            }
                        } label: {
                            Image(item.imageName)
                                .resizable()
                                .scaledToFit()
                        }
                        .buttonStyle(.plain)
                        .tag(index)
                    }
                }
                .background(Color.white)
                .cornerRadius(16)
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 180)
                

                /// 인디케이터
                HStack(spacing: 8) {
                    Spacer()
                    ForEach(0..<recommendationItems.count, id: \.self) { index in
                        Image(currentPage == index ? "indicator_selected" : "indicator_normal")
                            .resizable()
                            .frame(width: currentPage == index ? 18 : 8, height: 8)
                    }
                    Spacer()
                }
                .padding(.top, 8)

            }
        }
        
        /// AI 상담 배너
        private var aiCounselingBanner: some View {
            VStack(spacing: 16) {
                
                Text("내게 딱 맞는 AI 상담, 해보실래요?")
                    .font(.PretendardSemiBold(size: 16))
                    .foregroundStyle(.gray900)
                
                ZStack {
                    Capsule()
                        .fill(Color.green30)
                        .frame(width: 140, height: 28)
                    
                    Text("내 진단 결과 기반 분석")
                        .font(.PretendardMedium(size: 12))
                        .foregroundStyle(Color(hex: "73981F"))
                }
                
                Image("ai_helper")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                
                /// 채팅 화면으로 이동
                Button{
                    container.selectedTab = .chat
                } label: {
                    Text("정밀 상담 시작")
                        .font(.PretendardSemiBold(size: 16))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(.maingreen)
                        .cornerRadius(12)
                }
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(20)
        }
    }



//MARK: - Preview
#Preview {
    HomeView(container: .init())
}

