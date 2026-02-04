//
//  SendButton.swift
//  Symteo
//
//  Created by 김지우 on 2/1/26.
//

import SwiftUI

struct SendButton: View {
    let isDisabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: {
            action()
        }, label: {
            Image(systemName: "arrow.up")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)
                .padding(10)
                .background(isDisabled ? Color.gray200 : Color.green500)
                .clipShape(Circle())
        })
        .disabled(isDisabled)
    }
}
