//
//  LoginView.swift
//  Symteo
//
//  Created by 김지우 on 1/12/26.
//


import SwiftUI

struct LoginView: View {
    
    // MARK: - Property

    @StateObject private var viewModel = LoginViewModel()

    // MARK: - Body

    var body: some View {
        VStack(spacing: 8) {
            logoview

            Spacer()
                .frame(height:16)
            
            ForEach(viewModel.providers) { provider in
                        SocialLoginButton(icon: provider.icon, title: provider.title) {
                            viewModel.tapLogin(provider: provider)
                        }
                    }
                }
        .padding(.horizontal, 26)
        }
    
    
    // MARK: - Top Contents
    //로고+텍스트
    private var logoview: some View {
        VStack(){
            Image(.symlogoBig)
                .resizable()
                .scaledToFit()
                .frame(width: 550, height: 420)
            
            Text("나만의 멘탈 케어 솔루션")
                .font(.PretendardMedium(size: 16))
                .frame(maxWidth: .infinity, alignment: .leading)

            
        }
    }
    

    }
    
        
    
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



struct LoginView_Preview: PreviewProvider {
    static var devices = ["iPhone 17 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            LoginView()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
