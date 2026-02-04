//
//  OptionButton.swift
//  Symteo
//
//  Created by 김지우 on 2/5/26.
//

import SwiftUI

struct OptionButton: View {
    //필수 데이터
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    //커스텀 스타일 속성 (기본값 설정)
    private var fontSize: CGFloat = 14
    private var cornerRadius: CGFloat = 12
    private var verticalPadding: CGFloat = 8
    private var horizontalPadding: CGFloat = 16
    
    
    init(text: String, isSelected: Bool, action: @escaping () -> Void) {
        self.text = text
        self.isSelected = isSelected
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.PretendardRegular(size: fontSize))
                .foregroundColor(isSelected ? .green600 : .black)
                .padding(.vertical, verticalPadding)
                .padding(.horizontal, horizontalPadding)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(isSelected ? Color.green30 : Color.white)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(isSelected ? Color.green400 : Color.gray100, lineWidth: 1)
                )
        }
    }
}

// MARK: - Modifiers
extension OptionButton {
    
    /// 폰트 사이즈 변경
    func buttonFontSize(_ size: CGFloat) -> OptionButton {
        var copy = self
        copy.fontSize = size
        return copy
    }
    
    /// 모서리 둥글기 변경
    func buttonCornerRadius(_ radius: CGFloat) -> OptionButton {
        var copy = self
        copy.cornerRadius = radius
        return copy
    }
    
    /// 패딩 직접 조정 
    func buttonPadding(horizontal: CGFloat, vertical: CGFloat) -> OptionButton {
        var copy = self
        copy.horizontalPadding = horizontal
        copy.verticalPadding = vertical
        return copy
    }
}

