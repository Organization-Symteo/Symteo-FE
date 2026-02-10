//
//  SurveyOptionButton.swift
//  Symteo
//
//  Created by 김지우 on 2/9/26.
//

import SwiftUI

// MARK: - 설문용 옵션 버튼 컴포넌트
struct SurveyOptionButton: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.PretendardRegular(size: 14))
                .foregroundStyle(.gray700)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? Color.green30 : Color.gray30)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? Color.green400 : Color.clear, lineWidth: 1)
                )
        }
    }
}

#Preview {
    SurveyOptionButton(text: "그런 적 없음", isSelected: true, action: {print("그런 적 없음")})
}
