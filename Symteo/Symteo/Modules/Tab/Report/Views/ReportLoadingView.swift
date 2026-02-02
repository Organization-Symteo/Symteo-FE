//
//  ReportLoadingView.swift
//  Symteo
//
//  Created by 박병선 on 1/18/26.
//
import SwiftUI

struct ReportLoadingView: View {
    @State private var progress: Double = 0.0
    @Environment(\.dismiss) var dismiss
    
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    // 로딩 완료 여부 판단
    private var isCompleted: Bool {
        progress >= 1.0
    }

    var body: some View {
        VStack(spacing: 0) {
            // 상단 바 (뒤로가기 버튼 등)
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.black)
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            Spacer()

            // 로딩 중: 누워있는 늘보 / 완료: 서있는 늘보
            Image(isCompleted ? "home_neulbo" : "lying_neulbo")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .transition(.opacity.combined(with: .scale)) // 전환 시 부드러운 효과
                .id(isCompleted) // ID를 바꿔줘야 교체 애니메이션 적용됨
            
            Spacer()
                .frame(height: 40)

            // 2. 커스텀 프로그레스 바
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 300, height: 8)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(hex: "34A853")) // 디자인 가이드의 초록색
                    .frame(width: 300 * CGFloat(progress), height: 8)
            }
            .padding(.bottom, 30)

            // 3. 텍스트 정보 (상태에 따라 변경)
            VStack(spacing: 8) {
                Text(isCompleted ? "불러오기 완료!" : "리포트 불러오는 중...")
                    .font(.PretendardMedium(size: 16))
                
                Text(isCompleted ? "상담사와 이야기해보세요" : "잠시만 기다려주세요")
                    .font(.PretendardMedium(size: 16))
            }
            
            Spacer()
            Spacer()
        }
        .background(Color.white)
        .animation(.easeInOut, value: isCompleted) // 상태 변경 시 애니메이션 적용
        .onReceive(timer) { _ in
            if progress < 1.0 {
                progress += 0.01 // 속도는 프로젝트에 맞춰 조절하세요
            } else {
                timer.upstream.connect().cancel()
            }
        }
    }
}

#Preview {
    ReportLoadingView()
}
