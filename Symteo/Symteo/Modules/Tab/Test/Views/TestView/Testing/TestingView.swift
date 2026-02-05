//
//  SurveyView.swift
//  Symteo
//
//  Created by 김지우 on 1/25/26.
//

import SwiftUI

struct SurveyView: View {
    // 작성하신 ViewModel 사용
    @StateObject var viewModel = SurveyViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // 1. 헤더 (뒤로가기 버튼)
            headerView
            
            // 2. 프로그레스 바
            progressBar
                .padding(.top, 10)
                .padding(.bottom, 20)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    
                    // 3. 네비게이션 (숫자 카운터 & 화살표)
                    navigationRow
                        .padding(.bottom, 30)
                    
                    // 4. 질문 텍스트
                    Text(viewModel.currentQuestion.text)
                        .font(.system(size: 20, weight: .medium)) // Pretendard Medium 20 대체
                        .foregroundColor(.black)
                        .lineSpacing(6)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, 50)
                        .animation(nil, value: viewModel.currentIndex) // 텍스트는 즉시 변경
                    
                    // 5. 선택지 목록
                    VStack(spacing: 12) {
                        ForEach(viewModel.currentQuestion.options, id: \.self) { option in
                            SurveyOptionButton(
                                text: option,
                                isSelected: viewModel.isSelected(option)
                            ) {
                                viewModel.selectOption(option)
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
        }
        .navigationBarHidden(true)
        .background(Color.white)
    }
    
    // MARK: - Components
    
    // 상단 헤더
    private var headerView: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "arrow.left")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .foregroundColor(.black)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
    
    // 진행률 바
    private var progressBar: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // 배경 (회색)
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 4)
                
                // 진행 (초록색)
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.green) // 브랜드 컬러 코드 있으면 교체 (.green600 등)
                    .frame(width: geometry.size.width * viewModel.progress, height: 4)
                    .animation(.easeOut, value: viewModel.progress)
            }
        }
        .frame(height: 4)
        .padding(.horizontal, 24)
    }
    
    // 숫자 및 네비게이션 화살표
    private var navigationRow: some View {
        HStack {
            // "01" (Bold) + "/16" (Light)
            HStack(spacing: 0) {
                Text(viewModel.currentNumberString)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                
                Text(" / \(viewModel.totalCountString)")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // 화살표 버튼 그룹
            HStack(spacing: 8) {
                // 이전 버튼
                Button(action: { viewModel.prevQuestion() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14))
                        .foregroundColor(viewModel.currentIndex > 0 ? .black : .gray.opacity(0.3))
                        .frame(width: 32, height: 32)
                        .background(Color.gray.opacity(0.1)) // 연한 회색 배경
                        .cornerRadius(4)
                }
                .disabled(viewModel.currentIndex == 0)
                
                // 다음 버튼
                Button(action: { viewModel.nextQuestion() }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .frame(width: 32, height: 32)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(4)
                }
            }
        }
    }
}

// MARK: - 설문용 옵션 버튼 컴포넌트
struct SurveyOptionButton: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 14)) // Pretendard Regular 14
                .foregroundColor(isSelected ? .black : .gray) // 선택시 검정, 미선택시 회색
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? Color.green.opacity(0.1) : Color.gray.opacity(0.05))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? Color.green : Color.clear, lineWidth: 1)
                )
        }
    }
}

#Preview {
    SurveyView()
}
