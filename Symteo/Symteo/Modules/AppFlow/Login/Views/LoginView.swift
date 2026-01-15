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
    
    //약관 동의 여부
    @AppStorage("AgreeTerms") private var agreeTerms: Bool = false
    
    // 팝업 표시 상태
    @State private var showTermsPopup: Bool = false
    
    @State private var termsSheet: TermsSheetType? = nil


    // MARK: - Body

    var body: some View {
        ZStack{
            
            //약관 동의 팝업 오버레이
            if showTermsPopup{
                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                
                PopUpView(title: "심터의 이용약관 및 개인정보 취급방침에\n동의하고 시작합니다.",message:nil,confirmTitle: "동의하기", cancelTitle: "동의하지 않기", onConfirm: {
                    agreeTerms = true
                    showTermsPopup = false
                }, onCancel: {
                    showTermsPopup = true
                })
                .transition(.scale.combined(with: .opacity))
                
            }
            
            VStack(spacing: 8) {
                logoview
                
                Spacer()
                    .frame(height:16)
                
                ForEach(viewModel.providers) { provider in
                    SocialLoginButton(icon: provider.icon, title: provider.title) {
                        viewModel.tapLogin(provider: provider)
                    }
                }
                Spacer()
                    .frame(height:77)
                termsRow
            }//VStackend
            .allowsHitTesting(!showTermsPopup)
            .padding(.horizontal, 26)
        }//ZStackend
        .task{
            //agreeTerms = false //테스트용
            
            if !agreeTerms{
                await Task.yield()
                showTermsPopup = true
            }
        }
        .sheet(item: $termsSheet) { sheet in
            TermsBottomSheet(type: sheet)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)

        }
    }
    
    // MARK: - Top Contents
    //로고+텍스트
    private var logoview: some View {
        VStack{
            Image(.symlogoBig)
                .resizable()
                .scaledToFit()
                .frame(height: 420)
                .frame(maxWidth: .infinity)
                .clipped()

            
            Text("나만의 멘탈 케어 솔루션")
                .font(.PretendardMedium(size: 16))
                .frame(maxWidth: .infinity, alignment: .leading)

            
        }
    }
    
    // MARK: - Botton Contents
    //안심 이용약관 & 데이터 처리 동의
    private var termsRow: some View {
        HStack(spacing:2){
            Button {
                termsSheet = .safeTerms
            } label: {
                Text("안심 이용약관")
            }
            .buttonStyle(.plain)
            
            Text("&")
                .foregroundStyle(.gray400)

            
            Button {
                termsSheet = .dataConsent
            } label: {
                Text("데이터 처리 동의")
            }
            .buttonStyle(.plain)
        }
        .font(.PretendardMedium(size: 14))
        .foregroundStyle(Color.gray400)
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
