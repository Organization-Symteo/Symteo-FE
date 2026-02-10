//
//  CustomToggle.swift
//  Symteo
//
//  Created by 박정환 on 2/2/26.
//

import SwiftUI

struct CustomToggle: View {
    
    @Binding var isOn: Bool
    
    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                isOn.toggle()
            }
        } label: {
            ZStack {
                
                RoundedRectangle(cornerRadius: 13)
                    .fill(isOn ? Color.maingreen : Color.gray300)
                    .frame(width: 50, height: 26)
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 22, height: 22)
                    .offset(x: isOn ? 12 : -12)
            }
        }
        .buttonStyle(.plain)
    }
}
