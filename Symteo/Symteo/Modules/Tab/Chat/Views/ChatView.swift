//
//  ChatView.swift
//  Symteo
//
//  Created by 김지우 on 1/12/26.
//

import SwiftUI
import Foundation

struct ChatView: View {
    
    @StateObject var viewModel: ChatViewModel

    // MARK: - Init

    /// DIContainer을 주입받아 초기화
    init(
        container: DIContainer
    ) {
        _viewModel = StateObject(wrappedValue: ChatViewModel(container: container))
    }
    
    // MARK: - Body
    
    var body: some View{
            VStack {
                headerView
                Spacer()
                
                
                //chatMessageView

            inputField

        }
            .padding()


   
}
    // MARK: - Chat Header

    
    private var headerView: some View {
        ZStack(alignment:.trailing){
            HStack {
                Text("심터AI")
                    .frame(maxWidth: .infinity)
                    .font(.PretendardRegular(size: 16))
                    .foregroundStyle(.black)
                
            }
            
            Button(action: {
               
            }) {
                Image("consultsetting")
                    .resizable()
                    .frame(width: 44, height: 44)
                    .foregroundStyle(.gray700)
            }
        }
        .padding(.vertical, 12)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.gray100),
            alignment: .bottom
        )
    }
    
    // MARK: - Chat Message View
    @ViewBuilder
    private var chatMessageView: some View{
        HStack{
            Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(.gray400)

                // 날짜 텍스트
            Text("Date")
                    .font(.caption)
                    .foregroundStyle(.gray400)
                    .padding(.horizontal, 8)
                
            Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(.gray400)
        }
       
        if viewModel.messages.isEmpty {
            Text("AI 상담은 의학적 진단 및 치료가 아닌 정서적 지원을 제공합니다.")
                .font(.PretendardMedium(size: 12))
                .foregroundStyle(.gray100)
        }
    }
    
    
    // MARK: - Input Field
    
    private var inputField: some View {
        HStack {
            TextField(
                "",
                text: $viewModel.textInput,
                prompt: Text("메시지를 입력하세요...")
                    .foregroundStyle(.gray400)
            )
                .font(.PretendardMedium(size: 14))
                .foregroundStyle(.black)
                
                
            // MARK: - Send Button
            SendButton(
                isDisabled: viewModel.textInput.isEmpty,
                action: {
                    Task {
                        await viewModel.sendMessage()
                    }
                }
            )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 11.5)
        .background(
            RoundedRectangle(cornerRadius:34)
                .fill(.gray5)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 34)
                .stroke(.gray100, lineWidth: 0.8)
        }
    }
    
    // MARK: 스크롤 제일 아래 메세지로 향하게
    
    private func scrollToLastMessage(proxy: ScrollViewProxy) {
        guard let recentMessage = viewModel.messages.last else { return }
                            
        DispatchQueue.main.async {
            withAnimation {
                proxy.scrollTo(recentMessage.id, anchor: .bottom)
            }
        }
    }
    }

#Preview {
    ChatView(container: .init())
}
