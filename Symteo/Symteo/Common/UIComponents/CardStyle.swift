//
//  CardStyle.swift
//  Symteo
//
//  Created by 박정환 on 1/15/26.
//

import SwiftUI

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .shadow(
                color: Color.black.opacity(0.03),
                radius: 14,
                x: 0,
                y: 6
            )
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
}
