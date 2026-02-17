//  ChatView.swift
//  Symteo
//
//  Created by 김지우 on 2/11/26.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var container: DIContainer
    @StateObject private var viewModel = ChatViewModel()

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                header

                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            dateDivider(date: "2026년 1월 8일 목요일")

                            ForEach(viewModel.messages) { msg in
                                bubble(msg)
                                    .id(msg.id)
                            }

                            if !viewModel.isChatStarted {
                                Spacer().frame(height: 80)

                                Text("AI 상담은 의학적 진단 및 치료가 아닌 정서적 지원을 제공합니다.")
                                    .font(.PretendardRegular(size: 12))
                                    .foregroundStyle(.gray400)
                                    .padding(.vertical, 10)

                                Spacer().frame(height: 160)

                                reportQuickButtons
                            }

                            Color.clear.frame(height: 1).id("BOTTOM")
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                    .onChange(of: viewModel.shouldScrollToBottom) { _ in
                        withAnimation(.easeOut(duration: 0.25)) {
                            proxy.scrollTo("BOTTOM", anchor: .bottom)
                        }
                    }
                }

                inputBar
                    .padding(.horizontal, 20)
                    .padding(.bottom, 12)
            }

            if viewModel.isShowingEndPopup {
                endPopup
            }
        }
        .background(Color.white)
        .onAppear { viewModel.onAppearIfNeeded() }
        .alert("알림", isPresented: Binding(
            get: { viewModel.alertMessage != nil },
            set: { newValue in
                if !newValue { viewModel.clearAlert() }
            }
        )) {
            Button("확인") { viewModel.clearAlert() }
        } message: {
            Text(viewModel.alertMessage ?? "")
        }
    }

    private var header: some View {
        HStack {
            if viewModel.isChatStarted {
                Button { viewModel.tapEndIcon() } label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .foregroundStyle(.gray900)
                }
            } else {
                Color.clear.frame(width: 24, height: 24)
            }

            Spacer()

            Text("심터AI")
                .font(.PretendardMedium(size: 18))

            Spacer()

            Button {
                container.navigationRouter.push(.counselsetting)
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.gray900)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .overlay(Rectangle().frame(height: 1).foregroundStyle(.gray100), alignment: .bottom)
    }

    private func dateDivider(date: String) -> some View {
        HStack {
            Rectangle().frame(height: 1).foregroundStyle(.gray100)
            Text(date)
                .font(.PretendardRegular(size: 12))
                .foregroundStyle(.gray400)
                .layoutPriority(1)
            Rectangle().frame(height: 1).foregroundStyle(.gray100)
        }
        .padding(.vertical, 16)
    }

    private func bubble(_ msg: ChatMessage) -> some View {
        HStack(alignment: .top, spacing: 8) {
            if msg.role == .model {
                Circle()
                    .fill(Color.green400)
                    .frame(width: 40, height: 40)
                    .overlay(Image(systemName: "face.smiling").foregroundStyle(.white))

                VStack(alignment: .leading, spacing: 4) {
                    Text(msg.content)
                        .font(.PretendardRegular(size: 15))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.white)
                        .clipShape(RoundedCorner(radius: 12, corners: [.topRight, .bottomLeft, .bottomRight]))
                        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)

                    Text("11:24")
                        .font(.PretendardRegular(size: 10))
                        .foregroundColor(.gray400)
                }
                Spacer()
            } else {
                Spacer()
                Text(msg.content)
                    .font(.PretendardRegular(size: 15))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.green400)
                    .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .bottomLeft, .bottomRight]))
            }
        }
    }

    private var reportQuickButtons: some View {
        HStack(spacing: 12) {
            quickButton(title: "내 우울·불안\n리포트 불러오기", icon: "chatreport2") {
                viewModel.loadReport(
                    buttonTitle: "내 우울·불안 리포트 불러오기",
                    reportType: "DEPRESSION_ANXIETY_COMPLEX",
                    reportId: 0
                )
            }

            quickButton(title: "내 스트레스\n리포트 불러오기", icon: "chatreport1") {
                viewModel.loadReport(
                    buttonTitle: "내 스트레스 리포트 불러오기",
                    reportType: "STRESS_BURNOUT_COMPLEX",
                    reportId: 0
                )
            }
        }
        .padding(.top, 12)
    }

    private func quickButton(title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(icon)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.gray400)

                Spacer().frame(width: 10)

                Text(title)
                    .font(.PretendardMedium(size: 13))
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.gray900)
            }
            .frame(maxWidth: .infinity, minHeight: 70)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray100))
        }
    }

    private var inputBar: some View {
        HStack(spacing: 12) {
            TextField("메시지를 입력하세요...", text: $viewModel.textInput)
                .font(.PretendardRegular(size: 15))
                .padding(.horizontal, 16)
                .frame(height: 44)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(22)

            Button {
                viewModel.sendMessage()
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .resizable()
                    .frame(width: 36, height: 36)
                    .foregroundStyle(viewModel.textInput.isEmpty ? .gray200 : .green400)
            }
            .disabled(viewModel.textInput.isEmpty || viewModel.isSending)
        }
    }

    private var endPopup: some View {
        ZStack {
            Color.black.opacity(0.35).ignoresSafeArea()
            VStack(spacing: 24) {
                Text("상담을 종료하시겠습니까?")
                    .font(.PretendardMedium(size: 18))

                HStack(spacing: 12) {
                    Button("계속하기") { viewModel.cancelEnd() }
                        .font(.PretendardMedium(size: 16))
                        .foregroundStyle(.gray600)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.gray100)
                        .cornerRadius(12)

                    Button("종료하기") { viewModel.confirmEnd() }
                        .font(.PretendardMedium(size: 16))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.green400)
                        .cornerRadius(12)
                }
            }
            .padding(24)
            .background(Color.white)
            .cornerRadius(20)
            .padding(.horizontal, 30)
        }
    }
}

#Preview {
    ChatView()
        .environmentObject(DIContainer())
}
