//
//  MissionWritingView.swift
//  Symteo
//
//  Created by 박병선 on 1/12/26.
//
import SwiftUI

struct MissionWritingView: View {
    @ObservedObject var viewModel: MissionViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showPicker: Bool = false
    @State private var tempImage: UIImage? = nil
    @State private var showSubmitConfirm: Bool = false
    @State private var showExitConfirm: Bool = false
    @EnvironmentObject var container: DIContainer 

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                navigationBar

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        missionHeader
                        photoSection
                        memoSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }

                MainBottomButton(
                    text: "완료",
                    isDisabled: viewModel.selectedImages.isEmpty || viewModel.memo.isEmpty,
                    action: { withAnimation { showSubmitConfirm = true } }
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
            }
            .disabled(showSubmitConfirm || showExitConfirm)

            if showSubmitConfirm || showExitConfirm {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
            }

            if showSubmitConfirm {
                VStack {
                    Spacer()
                    /// 작성 완료 팝업
                    PopUpView (
                        title: "작성을 완료하셨나요?",
                        message: "[마이 심터 > 오늘 미션]에서 다시 볼 수 있어요.",
                        confirmTitle: "작성완료",
                        cancelTitle: "돌아가기",
                        onConfirm: {
                            showSubmitConfirm = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                viewModel.completeMission()
                            }
                        },
                        onCancel: { showSubmitConfirm = false }
                    )
                }
                .transition(.move(edge: .bottom))
            }

            /// 취소 팝업
            if showExitConfirm {
                PopUpView(
                    title: "미션을 그만두시겠습니까?",
                    message: "지금 나가시면 작성된 내용이 저장되지 않아요.",
                    confirmTitle: "계속하기",
                    cancelTitle: "그만두기",
                    onConfirm: { showExitConfirm = false },
                    onCancel: {
                        showExitConfirm = false
                        dismiss()
                    }
                )
                .padding(.horizontal, 19)
            }
        }
        .sheet(isPresented: $showPicker) {
            ImagePicker(image: $tempImage)
        }
        .onChange(of: tempImage) { newImage in
            if let image = newImage, viewModel.selectedImages.count < 3 {
                viewModel.selectedImages.append(image)
                tempImage = nil
            }
        }
    }

    // MARK: - Subviews
    private var navigationBar: some View {
        ZStack {
            HStack {
                Button(action: { showExitConfirm = true }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 16))
                        .foregroundStyle(.black)
                }
                Spacer()
            }
            Text("오늘의 미션")
                .font(.PretendardRegular(size: 14))
                .foregroundStyle(.gray600)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }

    private var missionHeader: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text(viewModel.timeRemainingString())
                .font(.PretendardMedium(size: 12))

            Text(viewModel.missionContent)
                .font(.PretendardRegular(size: 16))
                .lineSpacing(4)
        }
        .padding(20)
        .background(Color("gray5"))
        .cornerRadius(20)
    }

    private var photoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("사진")
                    .font(.PretendardSemiBold(size: 14))
                Spacer()
                Button("임시저장") {
                    viewModel.saveDraftIfNeeded(text: viewModel.memo)
                }
                .font(.PretendardRegular(size: 12))
                .foregroundStyle(.gray400)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    photoAddButton

                    ForEach(viewModel.selectedImages.indices, id: \.self) { index in
                        Image(uiImage: viewModel.selectedImages[index])
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .cornerRadius(20)
                    }
                }
            }
        }
    }

    private var memoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("메모")
                .font(.PretendardSemiBold(size: 14))


            TextEditor(text: $viewModel.memo)
                .frame(height: 150)
                .onChange(of: viewModel.memo) { _ in
                    viewModel.saveDraftIfNeeded(text: viewModel.memo)
                }

        }
    }

    private var photoAddButton: some View {
        Button(action: { showPicker = true }) {
            VStack {
                Image(systemName: "plus")
                
                Text("\(viewModel.selectedImages.count) / 3장")

            }
            .frame(width: 100, height: 100)
        }
        .disabled(viewModel.selectedImages.count >= 3)
    }
}

