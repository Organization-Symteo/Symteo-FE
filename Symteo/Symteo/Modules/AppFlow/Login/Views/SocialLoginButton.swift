//
//  SocialLoginButton.swift
//  Symteo
//
//  Created by 김지우 on 1/15/26.
//

import SwiftUI

// MARK: - Social Login Button Component
// 소셜로그인 버튼 뷰
struct SocialLoginButton: View{
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View{
     
        
        Button(action: action){
            HStack(spacing:0){
                Image(icon)
                    .resizable()
                    .frame(width: 24, height: 24)
                    
                Spacer()
                
                Text(title)
                    .font(.PretendardSemiBold(size: 16))
                    .foregroundStyle(.gray900)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()
                
                Color.clear
                    .frame(width: 24, height: 24) // 좌우 균형용 더미

            }
            .padding(.horizontal, 12)
            .frame(height: 52)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius:12)
                    .stroke(Color.gray200, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}


