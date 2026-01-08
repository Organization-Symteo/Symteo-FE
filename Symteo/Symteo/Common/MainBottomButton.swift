//
//  MainBottomButton.swift
//  Symteo
//
//  Created by 박정환 on 1/7/26.
//

import SwiftUI

struct MainBottomButton: View {
    let text: String
    let action: () -> Void
    var isDisabled: Bool = false

    /// 커스텀 버튼 생성자
    /// - Parameters:
    ///   - text: 버튼 안에 표시될 텍스트
    ///   - isDisabled: 버튼 비활성화 상태 여부
    ///   - action: 버튼 클릭 시 실행할 동작
    init(
        text: String,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.text = text
        self.isDisabled = isDisabled
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.PretendardSemiBold(size: 16))
                .frame(width: 340, height: 56)
        }
        .buttonStyle(MainButtonStyle(isDisabled: isDisabled))
        .disabled(isDisabled)
    }
}

#Preview {
    MainBottomButton(
        text: "다음",
        isDisabled: false,
        action: {
            print("다음")
        }
    )
}
