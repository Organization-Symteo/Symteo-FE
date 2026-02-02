//
//  HomeView.swift
//  Symteo
//
//  Created by 박병선 on 1/7/26.
//
import SwiftUI

// 오늘의 한 줄: api 받아오기
struct HomeView: View {
    // MARK: - Properties
    @State private var selectedWeather: EmotionWeather? = nil
    @State private var userName: String = "따오기" // 실제 유저 이름으로 수정예정
    private let recommendationCards = ["anxiety_test", "stress_test", "attachment_test"] // 추천검사
    private let recommendationItems = [
        RecommendationItem(imageName: "anxiety_test", type: .anxiety),
        RecommendationItem(imageName: "stress_test", type: .stress),
        RecommendationItem(imageName: "attachment_test", type: .attachment)]
    @State private var currentPage = 0 // 페이지 스와이프(현재페이지 추적)
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 상단 커스텀 네비게이션
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
            }
            .background(Color(hex: "F8F9FA")) // 전체 배경색 (필요시 수정)
        }
    }
}



// MARK: - Subviews
extension HomeView {
    
    // 1. 네비게이션 바
    private var navigationBar: some View {
        HStack{
            Image("home_logo") // 로고 에셋
                .resizable()
                .scaledToFit()
                .frame(width:40, height: 23)
            
            Text("심터")
                .font(.PretendardSemiBold(size: 18))
                .foregroundStyle(.maingreen)
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
    
    // 2. 나무늘보 헤더
    private var welcomeHeader: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 4) {
                Text("오늘의 한 줄")
                    .font(.PretendardMedium(size: 12))
                    .foregroundStyle(.green400)
                Text("작은 거 부터 하나씩 해보자 화이팅!")
                    .font(.PretendardSemiBold(size: 16))
                    .foregroundStyle(.gray700)
            }
            Spacer()
            Image("home_neulbo")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 70)
        }
    }
    
    
    // 3. 감정 날씨 섹션 (에셋 이미지 적용)
    private var emotionWeatherSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("오늘 나의 감정 날씨를 선택해봐요")
                .font(.system(size: 16, weight: .semibold))
            
            HStack(spacing: 16) {
                ForEach(EmotionWeather.allCases, id: \.self) { weather in
                    WeatherButton(// Home->Views->SubViews
                        weather: weather,
                        isSelected: selectedWeather == weather,
                        isAnySelected: selectedWeather != nil,
                        action: {
                            withAnimation(.spring()) {
                                if selectedWeather == weather {
                                    selectedWeather = nil
                                } else {
                                    selectedWeather = weather
                                }
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
    
    // 4. 오늘의 미션 카드
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
            
            NavigationLink(destination: MissionView()) {
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
    
    // 5. 추천 섹션
    private var recommendationSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            // 타이틀 (userName)
            HStack(spacing: 0) {
                Text("\(userName)") // MARK: 실제 userName으로
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
            
            // 이미지 스와이프 영역
            TabView(selection: $currentPage) {
                ForEach(0..<recommendationCards.count, id: \.self) { index in
                    Button {
                        // MARK: TODO (버튼 클릭시 동작)
                    } label: {
                        Image(recommendationCards[index])
                            .resizable()
                            .scaledToFit()
                    }
                    .buttonStyle(.plain)   //  버튼 기본 스타일 제거 (중요)
                    .tag(index)            // 현재 페이지 추적
                }
            }
            .background(Color.white)
            .cornerRadius(16)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 180)
            
            
            //  커스텀 인디케이터 (지정한 이미지로 변경)
            HStack(spacing: 8) {
                Spacer()
                ForEach(0..<recommendationCards.count, id: \.self) { index in
                    if currentPage == index {
                        // 선택된 상태의 이미지 (예: 긴 녹색 바 이미지)
                        Image("indicator_selected")
                            .resizable()
                            .frame(width: 18, height: 8)
                    } else {
                        // 선택되지 않은 상태의 이미지 (예: 회색 원 이미지)
                        Image("indicator_normal")
                            .resizable()
                            .frame(width: 8, height: 8)
                        
                    }
                }
                .padding(.top)
                Spacer()
            }
            .padding(.top, 8)
        }

    }
    
    
    // AI 상담배너
    private var aiCounselingBanner: some View {
        VStack {
            Text("내게 딱 맞는 AI 상담, 해보실래요?")
                .font(.PretendardSemiBold(size: 16))
                .foregroundStyle(.gray900)
            ZStack {
                // 1. 배경: 타원형 도형 (에셋의 green30 색상 적용)
                Capsule()
                    .fill(Color.green30) // 에셋에 정의된 green30 사용
                    .frame(width: 140, height: 28) // 디자인 수치에 맞게 조절
                
                // 2. 텍스트: 배경 위에 겹쳐짐
                Text("내 진단 결과 기반 분석")
                    .font(.PretendardMedium(size: 12))
                    .foregroundStyle(Color(hex: "73981F"))
            }
           
            Image("ai_helper")
                .resizable()
                .scaledToFit()
                .frame(height: 100)
            Button(action: {
                        // 상담 시작 액션
            }){
                Text("정밀 상담 시작")
                    .font(.PretendardSemiBold(size: 16))
                    .foregroundColor(.white)
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

#Preview {
    HomeView()
}
