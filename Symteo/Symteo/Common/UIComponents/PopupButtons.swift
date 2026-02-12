//
//  PopupButtons.swift
//  Symteo
//
//  Created by 박정환 on 1/13/26.
//

import SwiftUI

struct PopupConfirmButton: View {
    let text: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.PretendardSemiBold(size: 16))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 56)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.maingreen)
                )
        }
        .buttonStyle(.plain)
    }
}

struct PopupCancelButton: View {
    let text: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.PretendardSemiBold(size: 16))
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 56)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray100, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}
