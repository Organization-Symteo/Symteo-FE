//
//  CardStyle.swift
//  Symteo
//
//  Created by 박병선 on 1/25/26.
//
import SwiftUI

extension View {
    func reportCardStyle() -> some View {
        self
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(
                color: Color.black.opacity(0.03),
                radius: 14,
                x: 0,
                y: 6
            )
            .frame(maxWidth: .infinity)
    }
}
