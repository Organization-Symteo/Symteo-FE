//
//  ReportBottomBar.swift
//  Symteo
//
//  Created by 박병선 on 1/19/26.
//
import SwiftUI

struct ReportBottomBar: View {
    
    var body: some View {
        VStack(spacing: 12) {

            Button(action: {
                // TODO: 액션 추가
            }) {
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
                action: {
                    print("다른 검사하러 가기") // TODO: 액션 추가
                }
            )
        }
        .padding()
    }
}


#Preview {
    ReportBottomBar()
}
