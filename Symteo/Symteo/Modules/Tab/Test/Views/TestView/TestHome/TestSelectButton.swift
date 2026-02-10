//
//  TestSelectButton.swift
//  Symteo
//
//  Created by 김지우 on 1/22/26.
//

import SwiftUI



struct TestSelectButton: View {
    let title: String
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(title)
                .font(.PretendardSemiBold(size: 16))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.green400)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}


#Preview {
    TestSelectButton(title: "테스트 시작", onTap: {})
}
