//
//  ReportBottomBar.swift
//  Symteo
//
//  Created by 박병선 on 1/19/26.
//
import SwiftUI

/// 우울/불안 리포트, 애착 리포트 하위 바텀바
struct ReportBottomBar: View {
    
    // 외부에서 주입 받을 액션
    let onConsultTap: () -> Void
    let onOtherTestTap: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {

            Button(action: onConsultTap) {
                HStack {
                    Image("message_notify_circle")
                        .resizable()
                        .frame(width: 32, height: 32)
                    VStack(alignment: .leading) {
                        Text("AI 상담사와 함께")
                            .font(.PretendardSemiBold(size: 16))
                            .foregroundStyle(.green600)
                        Text("관계 패턴 깊이 들여다보기")
                            .font(.PretendardMedium(size: 14))
                            .foregroundStyle(.green600)
                    }
                   
                    Spacer()
                }
                .frame(width: 300, height: 25)
                .padding()
                .background(
                    LinearGradient(
                        colors: [
                            Color(hex: "#9EE3CF"),
                            Color(hex: "#E4F0CA")],
                        startPoint: .leading,
                        endPoint: .trailing))
                .cornerRadius(16)
            }

            MainBottomButton(
                text: "다른 검사하러 가기",
                isDisabled: false,
                action: onOtherTestTap
            )
        }
        .padding()
    }
}

/*
 // 사용방법
 ReportBottomBar(
     onConsultTap: {
         // 상담 화면 이동
         path.append(.aiConsult)
     },
     onOtherTestTap: {
         dismiss() // 메인 리포트로 돌아가기
     }
 )
 */
