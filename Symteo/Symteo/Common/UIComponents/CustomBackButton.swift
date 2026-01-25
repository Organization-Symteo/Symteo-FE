//
//  CustomBackButton.swift
//  Symteo
//
//  Created by 김지우 on 1/18/26.
//



import SwiftUI

struct CustomBackButton: View {
    // 버튼을 눌렀을 때 실행될 동작 (화면 이동 로직)
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Image(systemName: "arrow.left")
                .foregroundColor(.black)
                .padding(8) // 터치 영역 확보
        }
    }
}

