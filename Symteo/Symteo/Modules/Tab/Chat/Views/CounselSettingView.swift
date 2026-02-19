//
//  CounselSettingView.swift
//  Symteo
//
//  Created by 김지우 on 2/5/26.
//

import SwiftUI

struct CounselSettingView: View {

    let usage: CounselSettingUsage

    @StateObject private var viewModel = CounselSettingViewModel()
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var sessionManager: SessionManager
    @Environment(\.dismiss) private var dismiss

    @State private var showLoading = false

    var body: some View {
        VStack(spacing: 0) {
            customHeader

            // 상단 로딩 표시 (설정 프리필 조회)
            if viewModel.isLoading {
                HStack(spacing: 8) {
                    ProgressView()
                    Text("설정을 불러오는 중...")
                        .font(.PretendardRegular(size: 12))
                        .foregroundStyle(.gray500)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    Text("내게 맞는 상담 스타일을 설정해보세요")
                        .font(.PretendardRegular(size: 14))
                        .foregroundStyle(Color.gray400)
                        .padding(.top, 10)

                    ForEach(viewModel.sections) { section in
                        VStack(alignment: .leading, spacing: 14) {
                            HStack {
                                Text(section.title)
                                    .font(.PretendardBold(size: 14))
                                    .foregroundStyle(.gray900)
                            }

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(section.options, id: \.self) { option in
                                        optionButton(section: section, option: option)
                                    }
                                }
                            }
                        }
                    }

                    Spacer().frame(height: 50)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }

            saveButton
        }
        .navigationBarHidden(true)
        .background(Color.white)
        .onAppear {
            // onboarding 포함: 기존 설정이 있으면 프리필
            viewModel.loadExistingSettingIfNeeded()
        }
        .fullScreenCover(isPresented: $showLoading) {
            LoadingFlowView(
                title: "데이터 저장 중...",
                showsCompletionButtons: false,
                completedTitle: "저장 완료!"
            ) {
                sessionManager.applyCounselorConfigured()
                showLoading = false

                switch usage {
                case .onboarding:
                    break
                case .chatEdit, .myEdit:
                    dismiss()
                }
            }
        }
        .alert(
            "오류",
            isPresented: Binding(
                get: { viewModel.alertMessage != nil },
                set: { if !$0 { viewModel.alertMessage = nil } }
            ),
            actions: { Button("확인", role: .cancel) {} },
            message: { Text(viewModel.alertMessage ?? "") }
        )
    }

    private func optionButton(section: CounselSection, option: String) -> some View {
        let isSelected = viewModel.isSelected(sectionTitle: section.title, option: option)

        return Button(action: {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            viewModel.toggleOption(
                sectionTitle: section.title,
                option: option,
                isMultiSelect: section.isMultiSelect
            )
        }) {
            Text(option)
                .font(.PretendardMedium(size: 14))
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                .background(isSelected ? Color.green30 : Color.white)
                .foregroundStyle(isSelected ? Color.maingreen : Color.gray500)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? Color.green600 : Color.gray200, lineWidth: 1)
                )
                .cornerRadius(12)
        }
        // 프리필 로딩 중에는 조작 막기 (UI 흔들림 방지)
        .disabled(viewModel.isLoading || viewModel.isSaving)
    }

    private var customHeader: some View {
        ZStack {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.black)
                }
                Spacer()
            }

            HStack(spacing: 6) {
                Text("맞춤")
                    .font(.PretendardMedium(size: 12))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.maingreen)
                    .cornerRadius(12)

                Text("상담사 설정")
                    .font(.PretendardRegular(size: 14))
                    .foregroundStyle(.gray900)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .overlay(Rectangle().frame(height: 1).foregroundStyle(Color.gray100), alignment: .bottom)
    }

    private var saveButton: some View {
        Button(action: {
            viewModel.save(usage: usage) {
                showLoading = true
            }
        }) {
            ZStack {
                Text("저장")
                    .opacity(viewModel.isSaving ? 0 : 1)

                if viewModel.isSaving {
                    ProgressView()
                        .tint(.white)
                }
            }
            .font(.PretendardMedium(size: 16))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(Color.maingreen)
            .cornerRadius(12)
        }
        .disabled(viewModel.isSaving || viewModel.isLoading)
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

#Preview { CounselSettingView(usage: .chatEdit) }
