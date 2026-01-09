//
//  MainButtonStyle.swift
//  Symteo
//
//  Created by 박정환 on 1/7/26.
//

import SwiftUI

struct MainButtonStyle: ButtonStyle {
    let isDisabled: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(
                isDisabled
                ? Color.gray500
                : (configuration.isPressed ? Color.gray30 : Color.white)
            )
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        isDisabled
                            ? Color.gray100
                            : (configuration.isPressed ? Color.green400 : Color.maingreen)
                    )
            )
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
