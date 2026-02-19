//
//  SurveyView.swift
//  Symteo
//
//  Created by 김지우 on 1/25/26.
//

import SwiftUI


struct SurveyView: View {
    
    private enum Layout {
           static let questionBoxHeight: CGFloat = 170
           static let questionToOptionsSpacing: CGFloat = 24
       }
    
    @EnvironmentObject private var container: DIContainer
    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel: SurveyViewModel

    @State private var isModalPresented = false
    @State private var modalTitle = ""
    @State private var modalMessage: String? = nil
    @State private var modalConfirmTitle = ""
    @State private var modalCancelTitle: String? = nil
    @State private var modalConfirmAction: () -> Void = {}
    @State private var modalCancelAction: () -> Void = {}

    @State private var showLoading: Bool = false

    init(kind: SurveyKind, container: DIContainer) {
        _viewModel = StateObject(
            wrappedValue: SurveyViewModel(
                kind: kind,
                service: TestService(),
                container: container
            )
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar
            progressBar
                .padding(.top, 10)
                .padding(.bottom, 20)

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    headerRow
                        .padding(.bottom, 28)
                    ScrollView {
                                            Text(viewModel.currentQuestion.text)
                                                .font(.PretendardMedium(size: 20))
                                                .foregroundStyle(.gray900)
                                                .lineSpacing(6)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .fixedSize(horizontal: false, vertical: true)
                                        }
                                        .scrollIndicators(.hidden)
                                        .frame(height: Layout.questionBoxHeight)
                                        .clipped()

                                        Spacer().frame(height: Layout.questionToOptionsSpacing)

                                        VStack(spacing: 12) {
                                            ForEach(Array(viewModel.currentQuestion.options.enumerated()), id: \.offset) { idx, text in
                                                SurveyOptionButton(
                                                    text: text,
                                                    isSelected: viewModel.isSelected(optionIndex: idx)
                                                ) {
                                                    viewModel.select(optionIndex: idx)
                                                }
                                            }
                                        }

                                        if viewModel.isLast {
                                            MainBottomButton(
                                                text: viewModel.isSubmitting ? "제출 중..." : "제출",
                                                isDisabled: viewModel.isSubmitting
                                            ) {
                                                handleSubmitTap()
                                            }
                                            .frame(maxWidth: .infinity)
                                            .padding(.horizontal, -17)   

                                            .padding(.top,12)
                                            .padding(.bottom, 24)
                                        }
                                    }
                                    .padding(.horizontal, 24)
                                }
        }
        .navigationBarHidden(true)
        .background(Color.white)
        .modalPopup(
            isPresented: $isModalPresented,
            title: modalTitle,
            message: modalMessage,
            confirmTitle: modalConfirmTitle,
            cancelTitle: modalCancelTitle,
            dismissOnBackgroundTap: false,
            onConfirm: modalConfirmAction,
            onCancel: modalCancelAction
        )
        .onChange(of: viewModel.submitErrorMessage, initial: false) { _, msg in
            guard let msg else { return }
            showLoading = false
            presentAlert(title: "제출에 실패했어요", message: msg, confirm: "확인", cancel: nil) {}
        }
        .fullScreenCover(isPresented: $showLoading) {
            ReportLoadingFlowScreen(
                container: container,
                kind: viewModel.kind,
                reportId: viewModel.createdReportId,
                onTapHome: {
                    showLoading = false
                    container.navigationRouter.reset()
                    dismiss()
                },
                onTapReport: { reportId in
                    showLoading = false
                    container.navigationRouter.push(
                        viewModel.kind.reportDestination(reportId: reportId)
                    )
                }
            )
        }
    }

    private var topBar: some View {
        HStack {
            Button {
                presentExitConfirm()
            } label: {
                Image(systemName: "arrow.left")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.gray900)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }

    private var progressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 100)
                    .fill(Color.gray30)
                    .frame(height: 4)

                RoundedRectangle(cornerRadius: 100)
                    .fill(Color.green400)
                    .frame(width: geo.size.width * viewModel.progress, height: 4)
                    .animation(.easeOut, value: viewModel.progress)
            }
        }
        .frame(height: 4)
        .padding(.horizontal, 24)
    }

    private var headerRow: some View {
        HStack {
            HStack(spacing: 0) {
                Text(String(format: "%02d", viewModel.currentIndex + 1))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.gray900)
                Text(" / \(viewModel.questions.count)")
                    .font(.system(size: 14))
                    .foregroundStyle(.gray500)
            }

            Spacer()

            HStack(spacing: 8) {
                Button { viewModel.prev() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(viewModel.currentIndex > 0 ? .gray900 : .gray30)
                        .frame(width: 32, height: 32)
                        .background(Color.gray.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                .disabled(viewModel.currentIndex == 0)

                Button { viewModel.next() } label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.gray900)
                        .frame(width: 32, height: 32)
                        .background(Color.gray.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                .disabled(viewModel.isLast)
            }
        }
    }

    private func handleSubmitTap() {
        if viewModel.hasUnanswered {
            presentAlert(
                title: "아직 안푼 문항이 있어요",
                message: "정확한 결과를 위해 모든 문항에 답변해 주세요.",
                confirm: "돌아가기",
                cancel: "나가기",
                onConfirm: { viewModel.jumpToFirstUnanswered() },
                onCancel: { exitToTestHome() }
            )
        } else {
            presentAlert(
                title: "작성을 완료하셨나요?",
                message: nil,
                confirm: "작성완료",
                cancel: "돌아가기"
            ) {
                showLoading = true
                viewModel.submit()
            }
        }
    }

    private func presentExitConfirm() {
        presentAlert(
            title: "작성을 그만두시겠어요?",
            message: "지금 나가시면 진행 중인 내용이 저장되지 않습니다.",
            confirm: "돌아가기",
            cancel: "나가기",
            onConfirm: {},
            onCancel: { exitToTestHome() }
        )
    }

    private func presentAlert(
        title: String,
        message: String?,
        confirm: String,
        cancel: String?,
        onConfirm: @escaping () -> Void,
        onCancel: @escaping () -> Void = {}
    ) {
        modalTitle = title
        modalMessage = message
        modalConfirmTitle = confirm
        modalCancelTitle = cancel
        modalConfirmAction = onConfirm
        modalCancelAction = onCancel
        isModalPresented = true
    }

    private func exitToTestHome() {
        container.navigationRouter.reset()
        dismiss()
    }
}

#Preview {
    SurveyView(kind: .stress, container: DIContainer())
}
